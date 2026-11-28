.pragma library

function evaluate(expression) {
    let compact = expression.replace(/\s+/g, "");
    if (compact.endsWith("="))
        compact = compact.slice(0, -1);
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
