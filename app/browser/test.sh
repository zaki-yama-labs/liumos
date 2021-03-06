#!/bin/bash

assert() {
  expected="$1"
  input="$2"

  actual=$(./browser.bin --rawtext "$input" 2>&1)

  if [ "$actual" = "$expected" ]; then
    echo "input: $input => result: $actual"
  else
    echo "input: $input => $expected expected, but got $actual"
    exit 1
  fi
}

make clean
make

assert "bar" "bar"
assert "bar" "<html>bar</html>"
assert "bar" "<body>bar</body>"
assert "# bar" "<h1>bar</h1>"
assert "## bar" "<h2>bar</h2>"
assert "### bar" "<h3>bar</h3>"
assert "#### bar" "<h4>bar</h4>"
assert "##### bar" "<h5>bar</h5>"
assert "###### bar" "<h6>bar</h6>"
assert "- bar" "<ul><li>bar</li></ul>"
assert "- bar
- foo" "<ul><li>bar</li><li>foo</li></ul>"
assert "- bar
- foo

- foobar" "<ul><li>bar</li><li>foo</li></ul><ul><li>foobar</li></ul>"
assert "bar" "<p>bar</p>"

assert "bar" "<html><body>bar</body></html>"
assert "# bar" "<html><h1>bar</h1></html>"
assert "# bar" "<body><h1>bar</h1></body>"
assert "# bar" "<html><body><h1>bar</h1></body></html>"
assert "# bar

- abc
- def" "<html><body><h1>bar</h1><ul><li>abc</li><li>def</li></ul></body></html>"

assert "# bar" "<H1>bar</H1>"
assert "- abc
- def" "<HTML><BODY><UL><LI>abc</li><LI>def</li></ul></body></html>"

assert "# hoge

- bar

- foo" "<h1>hoge</h1><ul><li>bar</li></ul><ul><li>foo</li></ul>"

echo "----------------"
echo "All tests passed"
echo "----------------"
