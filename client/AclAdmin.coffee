objectTitle = (value)->
  title: CollectionForms.findOne(value)?.title or value
  url: Router.routes['AclAdmin'].path({objId: value})

grants = ->
  [
     {value:"read", title:"Read"},
     {value:"edit", title:"Edit"},
     {value:"own", title:"Own"},
  ];

aclForm = [
    {field: "obj", type: 'text', label: "User", clazz: "form-control", group:"details"},
    {field: "user", type: 'text', label: "User", clazz: "form-control", group:"details"},
    {field: "grant", type: 'select', rows:"3", label: "Grant", options: grants, clazz: "form-control", group:"details"},
]


class @AclAdminController extends RouteController
  subscriptions: ()->
    [Meteor.subscribe("adminAcl", @params.objId), Meteor.subscribe("adminUserContacts"),
     Meteor.subscribe("adminCollectionForms"), Meteor.subscribe("SharedTokens")]

  data: ()=>
    #d "AclAdminController subscribtions found #{Acl.find().count()} "+@ready();
    return unless @ready
    #d "Showing list for #{@params.objId}"
    query = if @params.objId then obj: @params.objId else {}
    forms = Acl.find(query).map (item)->
      formValues: createFormValues(aclForm, item)
      editMode: new ReactiveVar(false)
      _id: item._id
    forms.unshift
      formValues: createFormValues(aclForm, {})
      editMode: new ReactiveVar(true)
    result =
      form: aclForm
      forms: forms
      objId: @params.objId
      actions:
        save: (event, template)->
          values = getFormValues(aclForm, template)
          _id = @_id
          if _id
            d "Updating ACL", values
            Acl.update({_id:_id}, {$set: values})
          else
            d "Inserting ACL", values
            Acl.insert(values)

        remove: (event, template)->
          values = getFormValues(aclForm, template)
          d "Removing acl", @
          Acl.remove(@_id);
          @editMode.set(false);
