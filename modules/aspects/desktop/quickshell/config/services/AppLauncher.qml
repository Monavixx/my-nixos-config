pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.core
import qs.services

Singleton {
    id: root

    property string query: ""
    property var results: []
    property var websites: []

    readonly property string prefix: {
        const first = query.charAt(0);
        return ["=", "?", "!"].includes(first) ? first : "";
    }
    readonly property string searchText: prefix ? query.slice(1).trim() : query.trim()
    readonly property string mode: prefix === "=" ? "Calculator" : prefix === "?" ? "Web search" : prefix === "!" ? "Run command" : "Applications"

    onQueryChanged: refresh()

    Component.onCompleted: websiteFile.reload()

    FileView {
        id: websiteFile
        path: Quickshell.shellPath("websites.json")
        onLoaded: {
            try {
                const entries = JSON.parse(text());
                if (!Array.isArray(entries))
                    throw new Error("expected a JSON array");

                const validEntries = [];
                for (const entry of entries) {
                    if (!entry || typeof entry.name !== "string" || typeof entry.url !== "string" || !/^https?:\/\//i.test(entry.url)) {
                        console.error("[launcher] Ignoring invalid website entry:", JSON.stringify(entry));
                        continue;
                    }
                    validEntries.push({
                        name: entry.name,
                        url: entry.url,
                        keywords: Array.isArray(entry.keywords) ? entry.keywords.join(" ") : ""
                    });
                }
                root.websites = validEntries;
                root.refresh();
            } catch (error) {
                root.websites = [];
                console.error("[launcher] Could not parse websites.json:", error);
            }
        }
        onLoadFailed: error => {
            root.websites = [];
            console.error("[launcher] Could not load websites.json:", error);
        }
    }

    Connections {
        target: DesktopEntries
        function onApplicationsChanged() {
            root.refresh();
        }
    }

    function fuzzyScore(candidate, search) {
        const text = String(candidate || "").toLowerCase();
        const needle = search.toLowerCase();
        if (!needle)
            return 0;

        let score = 0;
        let previous = -2;
        let position = 0;
        for (let i = 0; i < needle.length; i++) {
            const found = text.indexOf(needle[i], position);
            if (found < 0)
                return -1;
            score += found === previous + 1 ? 12 : 0;
            score += found === 0 || /[\s._-]/.test(text[found - 1] || "") ? 8 : 0;
            score -= found * 0.1;
            previous = found;
            position = found + 1;
        }
        return score - (text.length - needle.length) * 0.02;
    }

    function matchScore(fields, search) {
        let best = -1;
        for (const field of fields)
            best = Math.max(best, fuzzyScore(field, search));
        return best;
    }

    function calculate(expression) {
        const compact = expression.replace(/\s+/g, "");
        const tokens = compact.match(/\d+(?:\.\d*)?|\.\d+|[()+\-*/%]/g) || [];
        if (!tokens.length || tokens.join("") !== compact)
            return null;

        let position = 0;
        let valid = true;
        function primary() {
            const token = tokens[position++];
            if (token === "+")
                return primary();
            if (token === "-")
                return -primary();
            if (token === "(") {
                const value = sum();
                if (tokens[position++] !== ")")
                    valid = false;
                return value;
            }
            if (!token || !/^(?:\d+(?:\.\d*)?|\.\d+)$/.test(token)) {
                valid = false;
                return 0;
            }
            return Number(token);
        }
        function product() {
            let value = primary();
            while (["*", "/", "%"].includes(tokens[position])) {
                const operator = tokens[position++];
                const right = primary();
                if (operator === "*")
                    value *= right;
                else if (operator === "/")
                    value /= right;
                else
                    value %= right;
            }
            return value;
        }
        function sum() {
            let value = product();
            while (tokens[position] === "+" || tokens[position] === "-") {
                const operator = tokens[position++];
                const right = product();
                value = operator === "+" ? value + right : value - right;
            }
            return value;
        }

        const value = sum();
        return valid && position === tokens.length && Number.isFinite(value) ? value : null;
    }

    function refresh() {
        const term = searchText;
        if (prefix === "=") {
            const result = term ? calculate(term) : null;
            results = result === null ? [] : [
                {
                    kind: "calc",
                    name: String(result),
                    detail: "Copy result"
                }
            ];
            return;
        }
        if (prefix === "?") {
            results = term ? [
                {
                    kind: "web",
                    name: "Search the web for “" + term + "”",
                    detail: "Open in your default browser",
                    query: term
                }
            ] : [];
            return;
        }
        if (prefix === "!") {
            results = term ? [
                {
                    kind: "command",
                    name: term,
                    detail: "Run command"
                }
            ] : [];
            return;
        }

        const matches = [];
        for (const entry of DesktopEntries.applications.values) {
            if (!entry || entry.noDisplay)
                continue;
            const score = matchScore([entry.name, entry.genericName, entry.comment, Array.isArray(entry.keywords) ? entry.keywords.join(" ") : ""], term);
            if (score >= 0)
                matches.push({
                    kind: "app",
                    name: entry.name,
                    detail: entry.genericName || entry.comment || "",
                    icon: entry.icon || "",
                    entry,
                    score
                });
        }
        for (const website of websites) {
            const score = matchScore([website.name, website.keywords, website.url], term);
            if (score >= 0)
                matches.push({
                    kind: "website",
                    name: website.name,
                    detail: website.url,
                    icon: "",
                    url: website.url,
                    score
                });
        }
        matches.sort((a, b) => b.score - a.score || a.name.localeCompare(b.name));
        results = matches.slice(0, 10);
    }

    function activate(result) {
        if (!result)
            return;
        switch (result.kind) {
        case "app":
            result.entry.execute();
            break;
        case "website":
            Qt.openUrlExternally(result.url);
            break;
        case "calc":
            Quickshell.execDetached(["wl-copy", result.name]);
            break;
        case "web":
            {
                const url = Config.webSearchUrlTemplate.replace("{query}", encodeURIComponent(result.query));
                Qt.openUrlExternally(url);
                break;
            }
        case "command":
            Quickshell.execDetached(["sh", "-lc", result.name]);
            break;
        }
        Shortcuts.closeLauncher();
    }
}
