#! /usr/bin/env expect -f

source [file join [file dirname $argv0] common.tcl]

start_server $argv

spawn $argv sql
eexpect root@

start_test "Check that a standalone '?' prints all help."
send "?\r"
eexpect "TRUNCATE"
eexpect "SHOW"
eexpect "ROLLBACK"
eexpect root@
end_test

start_test "Check that a ? after a simple statement prints help."
send "select ?\r"
eexpect "Command: "
eexpect "SELECT"
eexpect "data manipulation"
eexpect "FROM"
eexpect "ORDER BY"
eexpect "See also"
eexpect root@

send "select * from ?\r"
eexpect "Command: "
eexpect "data source"
eexpect "JOIN"
eexpect "EXPLAIN"
eexpect "SHOW"
eexpect "See also"
eexpect root@
end_test

start_test "Check that the last statement with help text made it to history."
send "\033\[A"
eexpect "select"
eexpect "from ?"
send "\r"
eexpect "See also"
eexpect root@
end_test

start_test "Check that a ? in a function call context prints help about that function."
send "select count(?\r"
eexpect "Function: "
eexpect "count"
eexpect "built-in functions"
eexpect "Signature"
eexpect "See also"
eexpect root@
end_test

# Finally terminate with Ctrl+C.
interrupt
eexpect eof

stop_server $argv
