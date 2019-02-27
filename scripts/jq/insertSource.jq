def walk(f):
  . as $in
  | if type == "object" then
      reduce keys_unsorted[] as $key
        ( {}; . + { ($key):  ($in[$key] | walk(f)) } ) | f
  elif type == "array" then map( walk(f) ) | f
  else f
  end;

. | walk(
    if type == "object" and has("_type") then
    to_entries
      | .[0:1] + [{key: "source", value: $source}] + .[1:]
      | from_entries
      else
      .
      end
)
