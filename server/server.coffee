###
This block add one documents into each collection(Documents and Friends)
at starting of Meteor
###
Meteor.startup ->
  if Documents.find().count() is 0
    Documents.insert
      name: "Sample doc"
      text: "Write here..."

  if Friends.find().count() is 0
    Friends.insert
      name: "Shyam"
      type: "Buddy"