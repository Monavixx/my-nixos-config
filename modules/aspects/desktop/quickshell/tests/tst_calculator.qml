import QtQuick
import QtTest
import "../config/services/Calculator.js" as Calculator

TestCase {
    name: "Calculator"

    function test_live_expression() {
        compare(Calculator.evaluate("12 + 3 * 2"), 18);
        compare(Calculator.evaluate("12 + 3 * 2="), 18);
    }

    function test_parentheses_and_unary_operators() {
        compare(Calculator.evaluate("-(2 + 3) * 4"), -20);
    }

    function test_incomplete_or_invalid_expression() {
        compare(Calculator.evaluate("2 +"), null);
        compare(Calculator.evaluate("(2 + 3"), null);
        compare(Calculator.evaluate("2 + nope"), null);
    }

    function test_non_finite_result() {
        compare(Calculator.evaluate("1 / 0"), null);
    }
}
