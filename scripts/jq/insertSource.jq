to_entries
  | .[0:1] + [{key: "source", value: $source}] + .[1:]
  | from_entries
