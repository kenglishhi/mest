
Ext.bio.DatabaseGroupTree =  Ext.extend(Ext.tree.TreePanel, {
  dataUrl: null,
  treeData: null,
  initComponent: function() {

    var rootNode = new Ext.tree.AsyncTreeNode(this.treeData);

    var store = new Ext.data.ArrayStore({
      fields: ['id', 'name'],
      data : Ext.workbenchdata.project_options // from states.js
    })
    var combo = new Ext.form.ComboBox({
      store: store,
      displayField: 'name',
      typeAhead: true,
      mode: 'local',
      triggerAction: 'all',
      emptyText:'Select a Project...',
      selectOnFocus:true,
      width:135
    });

    // set the root node
    var rootNode = new Ext.tree.AsyncTreeNode({
      text: 'Ext JS',
      draggable:false, // disable root node dragging
      id:'src'
    });

    Ext.apply(this,{
      animate: true,
      autowidth: true,
      autoheight: true,
      autoScroll:true,
      border: false,
      enableDD: true,
      rootVisible: false,

      tbar: [ combo, '->',
      {
        text: 'Add Database Group',
        handler: this.addDatabaseGroup
      }],
      loader: new Ext.tree.TreeLoader({
        dataUrl:'/workbench/tree/',
        requestMethod: "GET",
        headers: {
          'Accept' : 'text/javascript, text/html, application/xml, text/xml',
          'AjaxFrom' : 'EXTJS'
        }

      }) ,
      root: rootNode
    });



    Ext.bio.DatabaseGroupTree.superclass.initComponent.call(this);

  },
  listeners: {
    movenode: function( tree, node, oldParent, newParent, index )  {

      if (newParent.id != oldParent.id) {
        console.log("node.attributes.resource = " + node.attributes.resource);
        params ={};
        if (node.attributes.resource == 'biodatabase') {
          url = '/workbench/biodatabases/' + node.id + '/move';
          params = {
            new_biodatabase_group_id:  newParent.id,
            authenticity_token:  FORM_AUTH_TOKEN
          };
        } else if (node.attributes.resource == 'biodatabase_group') {
          url = '/workbench/biodatabase_groups/' + node.id + '/move';
          params = {
            new_parent_id:  newParent.id,
            authenticity_token:  FORM_AUTH_TOKEN
          };
        } else {
          return true;
        }

        Ext.Ajax.request({
          url: url,
          method: 'POST',
          params: params,
          headers: {
            'Accept' : 'text/javascript, text/html, application/xml, text/xml',
            'AjaxFrom' : 'EXTJS'
          },
          success: function(response, options) {
          },
          failure: function(response, options) {
          }
        });


      } 
    },
    click: function(node) {
      console.log("click STUB");
    },
    collapsenode: function(node) {
      console.log("collapsenode STUB");
    },
    expandnode: function(node) {
      console.log("expandnode STUB");
    }
  },
  addDatabaseGroup: function(){
    Ext.Msg.prompt('New Database group', 'Enter new database group name:',
      function(btn, text){
        var dbTree = Ext.getCmp('bio-database-group-tree');
        if(btn == 'ok' && text) {
          console.log("new Database Group" + text);
          url = '/workbench/biodatabase_groups';
          params = {
            parent_id :  dbTree.root.id,
            name: text,
            authenticity_token:  FORM_AUTH_TOKEN
          };
          Ext.Ajax.request({
            url: url,
            method: 'POST',
            params: params,
            headers: {
              'Accept' : 'text/javascript, text/html, application/xml, text/xml',
              'AjaxFrom' : 'EXTJS'
            },
            success: function(response, options) {
              var object =  Ext.util.JSON.decode(response.responseText);

              var newNode = new Ext.tree.TreeNode({
                text: text,
                expandable:true,
                leaf: false,
                id: object.id,
                resource: 'database_group'
              });

              dbTree.root.appendChild(newNode);
            },
            failure: function(response, options) {
            }
          });
        }
      });
  }
});
Ext.reg('database-group-tree', Ext.bio.DatabaseGroupTree);

