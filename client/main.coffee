Router.configure({})

Router.map () ->
  @route 'AclAdmin', path: '/admin/acl/list/:objId?', controller: 'AclAdminController'
