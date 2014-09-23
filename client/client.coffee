DocumentsRouter = Backbone.Router.extend(
  routes:
    ":document_id": "main"

  main: (document_id) ->
    Session.set "document_id", document_id

  setDocument: (document_id) ->
    @navigate(document_id, true)
)

Router = new DocumentsRouter
Meteor.startup ->
  Backbone.history.start pushState: true
###
This block for list friends name to share user's documents
###
Template.documentList.documents = ->
  Documents.find({"sharedUsers":{$in:[Meteor.user()._id]}},
    sort:
      name: 1
  )

Template.documentList.friends = ->
  Meteor.users.find({})
###
This block for creating new document by clicking on create button
###
Template.documentList.events =
  'click #new-document': (e) ->
    name = $('#new-document-name').val()
    if isNotEmpty(name)
      checkedValue = new Array()
      currUser = 0
      $.each $("input[name='sharedCheckbox[]']:checked"), ->
        currUser = 1  if $(this).val() is Meteor.user()._id
        checkedValue.push $(this).val()
      checkedValue.push Meteor.user()._id  if currUser is 0
      if name
        Documents.insert(
          name: name
          text: ""
          sharedUsers:checkedValue
        )
      $('#new-document-name').val('')
###
This block for deleting document
###
Template.document.events =
  'click #delete-document': (e) ->
    result = confirm("Are yo Want to delete this documet?")
    if result
      if Meteor.user
        Documents.remove(@_id)
  'click #edit-document': (e) ->
    Router.setDocument(@_id)

Template.document.selected = ->
  if Session.equals("document_id", @_id) then "selected" else ""
###
This block for get selected documents details from Document collection
###
Template.documentView.selectedDocument = ->
  document_id = Session.get("document_id")
  Documents.findOne(
    _id: document_id
  )
###
This block for save document data into collection in each Keyup events 
###
Template.documentView.events =
  'keyup #document-text': (e) ->
    # @_id should work here, but it doesn't
    sel = _id: Session.get("document_id")
    mod = $set: text: $('#document-text').val()
    Documents.update(sel, mod)

###
This block for validations
###
trimInput = (value) ->
  value.replace /^\s*|\s*$/g, ""

isNotEmpty = (value) ->
  return true  if value and value isnt ""
  Session.set "alert", "Please fill in all required fields."
  false

isEmail = (value) ->
  filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
  return true  if filter.test(value)
  Session.set "alert", "Please enter a valid email address."
  false

isValidPassword = (password) ->
  if password.length < 6
    Session.set "alert", "Your password should be 6 characters or longer."
    return false
  true

areValidPasswords = (password, confirm) ->
  return false  unless isValidPassword(password)
  if password isnt confirm
    Session.set "alert", "Your two passwords are not equivalent."
    return false
  true

Template.alert.helpers alert: ->
  Session.get "alert"
###
This block for signup form validation
###
Template.signUp.events "submit #signUpForm": (e, t) ->
  e.preventDefault()
  signUpForm = $(e.currentTarget)
  username = signUpForm.find("#signUpUname").val()
  email = trimInput(signUpForm.find("#signUpEmail").val().toLowerCase())
  password = signUpForm.find("#signUpPassword").val()
  passwordConfirm = signUpForm.find("#signUpPasswordConfirm").val()
  if isNotEmpty(username) and isNotEmpty(email) and isNotEmpty(password) and isEmail(email) and areValidPasswords(password, passwordConfirm)
    Accounts.createUser
      username:username
      email: email
      password: password
    , (err) ->
      if err
        if err.message is "Email already exists. [403]"
          Session.set "alert", "We're sorry but this email is already used."
        else
          Session.set "alert", "We're sorry but something went wrong."
      else
        Session.set "alert", "Congrats! You're now a new Meteorite!"

  false
###
This block for signout
###
Template.signOut.events "click #signOut": (e, t) ->
  Meteor.logout ->
    Session.set "alert", "Bye Meteorite! Come back whenever you want!"

  false
###
This block for signin authentication
###
Template.signIn.events "submit #signInForm": (e, t) ->
  e.preventDefault()
  signInForm = $(e.currentTarget) 
  email = trimInput(signInForm.find(".email").val().toLowerCase())
  password = signInForm.find(".password").val()
  if isNotEmpty(email) and isEmail(email) and isNotEmpty(password) and isValidPassword(password)
    Meteor.loginWithPassword email, password, (err) ->
      if err
        Session.set "alert", "We're sorry but these credentials are not valid."
      else
        Sesson.set "alert", "Welcome back New Meteorite!"

  false