name "ispconfig3"
description "ISPConfig 3 Server Install & Configure"
run_list(
    "recipe[apt]",
    "recipe[ispconfig3]"
)
override_attributes()
