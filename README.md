# forms-neld-row-table
Demonstration of forms-frame
Most important file is client/AclAdmin.coffee
it prepares rows 
```
    forms = Acl.find(query).map (item)->
      formValues: createFormValues(aclForm, item)
      editMode: new ReactiveVar(false)
      _id: item._id

```
calling 
```
createFormValues(aclForm, item)
```
for each Acl collection item to create form in row

client/AclAdmin.html just call the NeldRowsTable described in packages/forms-neld-row-table/NeldRowsTable.html 
which iterates through those forms showing either value or form if the row is in edit mode
```
    <tbody>
      {{#each forms}}
      <tr>
        {{#each formValues}}
          <td>
            {{#if ../editMode.get}}
              {{> getFieldTemplate}}
            {{else}}
              {{> getValueTemplate}}
            {{/if}}
          </td>
        {{/each}}
```
