# NotReddit.Umbrella

# create a migration

mix ecto.gen.migration add_topics

# run migration

mix ecto.migrate

## to create a html

go to web dir
`mix phx.gen.html Topic topics name:string text:string`
