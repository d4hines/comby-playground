cat input > output

sed -i -e '1,2d' output
sed -i 's/Estimated.*//' output
sed -i 's/:/, /g' output
sed -i 's/ Gas/, Gas/g' output
sed -i -e '17,20d' output
sed -i -e '$d' output

COMBY_M="$(cat <<"MATCH"
│ :[contract],  :[test] │ :[time]:[unit~ns] :[any\n]

MATCH
)"

COMBY_R="$(cat <<"REWRITE"
:[contract], :[test], Clock Time, :[time]
!
REWRITE
)"

COMBY_RULE="$(cat <<"RULE"
where
rewrite :[time] { ":[underscore~_]" -> "" }
RULE
)"

# Install comby with `bash <(curl -sL get.comby.dev)` or see github.com/comby-tools/comby && \
comby "$COMBY_M" "$COMBY_R" -rule "$COMBY_RULE" -f .txt ./output -in-place

sed -i -e 's/^!//' output

sed -i -e 's/^/G (5f95d773f), /' output