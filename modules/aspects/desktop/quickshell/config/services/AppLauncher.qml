pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.core
import qs.services
import "Calculator.js" as Calculator

Singleton {
    id: root

    property string prefix: ""
    property string query: ""
    property var results: []
    property var websites: []

    readonly property string mode: prefix === "=" ? "Calculator" : prefix === "?" ? "Web search" : prefix === "!" ? "Run command" : "Applications"

    onQueryChanged: refresh()
    onPrefixChanged: refresh()

    Component.onCompleted: websiteFile.reload()

    function setInput(value) {
        if (["=", "?", "!"].includes(value.charAt(0))) {
            prefix = value.charAt(0);
            query = value.slice(1);
            return query;
        }
        query = value;
        return value;
    }

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

    function refresh() {
        const term = query.trim();
        if (prefix === "=") {
            const result = term ? Calculator.evaluate(term) : null;
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
            const keywords = entry.keywords ? Array.from(entry.keywords).join(" ") : "";
            const categories = entry.categories ? Array.from(entry.categories).join(" ") : "";
            const score = matchScore([entry.name, entry.genericName, entry.comment, keywords, categories], term);
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
        results = matches;
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
