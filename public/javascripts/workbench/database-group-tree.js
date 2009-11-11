Ext.bio.DatabaseGroupTree =  Ext.extend(Ext.tree.TreePanel, {
  dataUrl: null,
  treeData: null,
  projectOptions:null,
  initComponent: function() {
    var myId = this.id;
    var rootNode = new Ext.tree.AsyncTreeNode({
      text: 'Ext JS',
      draggable:false, // disable root node dragging
      id:'src'
    });

    var parentComponentId = this.id;
    Ext.apply(this,{
      //      animate: true,
      autowidth: true,
      autoheight: true,
      autoScroll:true,
      containerScroll: true,
      border: false,
      enableDD: true,
      rootVisible: false,
      /*
      tbar: [ 
            {
        text: 'Add Database Group',
        handler: this.addDatabaseGroup
      },'->',
      {
        iconCls:'x-tbar-loading',
        handler: function() {
          var dbTree= Ext.getCmp(parentComponentId);
          if (dbTree) {
            dbTree.refresh();
          }
        }
      },
      ],
      */
      bbar :[{
        id:'tree-delete-icon',
        disabled: true,
        iconCls:'x-tree-delete',
        text: 'Delete',
        handler: function() {
          Ext.getCmp(myId).deleteSelectedNode;
        }
      },'->',
      {
        iconCls:'x-tbar-loading',
        handler: function() {
          var dbTree= Ext.getCmp(parentComponentId);
          if (dbTree) {
            dbTree.refresh();
          }
        }
      }
      ],
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
  deleteSelectedNode : function(node) {
    var dbTree= this;
    if (!node) {
      var node = this.getSelectionModel().getSelectedNode();
    }
    node.getUI().addClass('x-tree-node-loading');
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
    beforecollapsenode: function(node) {
      node.getUI().addClass('x-tree-node-loading');
    },
    collapsenode: function(node) {
      node.getUI().removeClass('x-tree-node-loading');
    },

    beforeexpandnode: function(node) {
      node.getUI().addClass('x-tree-node-loading');
    },
    expandnode: function(node) {
      node.getUI().removeClass('x-tree-node-loading');
    },
    contextmenu: function(node){
      //Set up some buttons
      var myId = this.id;
      var contextMenu;

      var deleteButton = new Ext.menu.Item({
        iconCls:'x-tree-delete',
        text: 'Delete',
        handler: function() {
          Ext.getCmp(myId).deleteSelectedNode(node);
        }
      });

      if (node.attributes.resource == 'biodatabase') {

        var renameButton = new Ext.menu.Item({
          iconCls:'new_fasta',
          text: "Rename Sequences",
          handler: function() {
            Ext.bio.showBiodatabaseRenamerWindow(node.id);
          }
        });

        var blastButton = new Ext.menu.Item({
          iconCls:'new_view',
          text: "Blast",
          handler: function() {
            Ext.bio.showBlastCreateDbsWindow(node.id);
          }
        });

        if (node.attributes.db_type == "Generated Match DB") {
          var clustalwButton = new Ext.menu.Item({
            iconCls:'clustalw',
            text: "ClustalW",
            handler: function() {
              Ext.bio.showClustalwWindow(node.id);
            }
          });

          contextMenu  = new Ext.menu.Menu({
            items: [ clustalwButton,'-',deleteButton]
          });
        } else if (node.attributes.db_type == "Uploaded Cleaned Database") {
          contextMenu  = new Ext.menu.Menu({
            items: [renameButton, blastButton, '-', deleteButton]
          });
        } else if (node.attributes.db_type == "Uploaded Raw Data") {
          var cleanButton = new Ext.menu.Item({
            iconCls:'book',
            text: "Clean DB",
            handler: function() {
              Ext.bio.showBlastCleanerWindow(node.id);
            }
          });

          contextMenu  = new Ext.menu.Menu({
            items: [renameButton, cleanButton, blastButton, '-', deleteButton]
          });
        } else {

          contextMenu  = new Ext.menu.Menu({
            items: [deleteButton]
          });
        }
      }
      else if (node.attributes.resource == 'biodatabase_group') {
        contextMenu  = new Ext.menu.Menu({
          items: [deleteButton]
        });
      }
      contextMenu.show(node.ui.getAnchor());
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

