
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

    var parentComponentId = this.id;
    Ext.apply(this,{
      animate: true,
      autowidth: true,
      autoheight: true,
      autoScroll:true,
      border: false,
      enableDD: true,
      rootVisible: false,

      tbar: [ combo,
      {
        iconCls:'x-tbar-loading',
        handler: function() {
          var dbTree= Ext.getCmp(parentComponentId);
          if (dbTree) {
            dbTree.refresh();
          }
        }
      }, '->',
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
  refresh: function(){
    this.getLoader().load(this.root);
  },
  deleteSelectedNode : function() {
    var dbTree= this;

    var node = this.getSelectionModel().getSelectedNode();
    var url;
    if (node.attributes.resource == 'biodatabase') {
      url = "/workbench/biodatabases/" + node.id + ".json" ;
    }
    else if (node.attributes.resource == 'biodatabase_group') {
      url = "/workbench/biodatabase_groups/" + node.id + ".json" ;
    }
    if (url) {
      Ext.Ajax.request({
        url: url ,
        headers: {
          'Content-Type':	'application/json'
        },
        method: 'DELETE',
        success: function() {
          dbTree.refresh();
        }
      });
    }
  },
  listeners: {
    click: function(node) {
      this.clickAction(node);
    },
    movenode: function( tree, node, oldParent, newParent, index )  {
      if (newParent.id != oldParent.id) {
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
    collapsenode: function(node) {
    },
    expandnode: function(node) {
    }
  },
  addDatabaseGroup: function(){
    Ext.Msg.prompt('New Database group', 'Enter new database group name:',
      function(btn, text){
        var dbTree = Ext.getCmp('bio-database-group-tree');
        if(btn == 'ok' && text) {
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

