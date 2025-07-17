pause() {
  read -p "Press Enter to continue..."
}

MY_LOG_SIGN="=========>"
TABLES=("filter" "nat" "mangle" "raw" "security")
for table in "${TABLES[@]}"; do
  echo "$MY_LOG_SIGN iptables --table $table --list --verbose --numeric"
  iptables --table $table --list --verbose --numeric
  pause
  echo "$MY_LOG_SIGN iptables --table $table --list-rules --verbose --numeric"
  iptables --table $table --list-rules --verbose --numeric
  pause
done

