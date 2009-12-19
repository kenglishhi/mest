Ext.bio.WorkbenchTree =  Ext.extend(Ext.tree.TreePanel, {
  dataUrl: null,
  treeData: null,
  projectOptions:null,

  initComponent: function() {
    var rootNode = new Ext.tree.AsyncTreeNode({
      text: 'Ext JS',
      draggable:false, // disable root node dragging
      id:'src'
    });

    var parentComponentId = this.id;
    Ext.apply(this,{
      autowidth: true,
      autoheight: true,
      autoScroll:true,
      containerScroll: true,
      border: false,
      enableDD: true,
      rootVisible: false,
      tbar :['->',
      {
        dbTree: this,
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
    Ext.bio.WorkbenchTree.superclass.initComponent.call(this);
  },
  postRefresh: function(){
  // STUB
  },
  refresh: function(){
    this.getLoader().load(this.root);
    this.postRefresh();
  },
  deleteSelectedNode : function(node) {
    var dbTree= this;
    if (!node) {
      node = this.getSelectionModel().getSelectedNode();
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
          dbTree.postDeleteAction();
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
        var params ={};
        var url ;
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
    contextmenu: function(node) {
      var contextMenu;
      var deleteButton = new Ext.menu.Item({
        iconCls:'x-tree-delete',
        text: 'Delete',
        treeId: this.id,
        nodeText: node.text,
        handler: function(b) {
          Ext.MessageBox.confirm('Confirm', 'Are you sure you want to delete "' + b.nodeText +'"?',
            function(btn){
              if (btn == 'yes') {
                Ext.getCmp(b.treeId).deleteSelectedNode(node);
              }
            });
        }
      });

      if (node.attributes.resource == 'biodatabase' && node.text !="Databases" ) {
        if (node.attributes.db_type == "Uploaded Raw Data" ) {
          var renameButton = new Ext.menu.Item({
            iconCls:'new_fasta',
            text: "Rename Sequences",
            handler: function() {
              Ext.bio.showBiodatabaseRenamerWindow(node);
            }
          });
        }

        var blastButton = new Ext.menu.Item({
          iconCls:'blast',
          text: "Blast",
          handler: function() {
            Ext.bio.showBlastCreateDbsWindow(node);
          }
        });

        if (node.attributes.db_type == "Generated Match DB") {
          var clustalwButton = new Ext.menu.Item({
            iconCls:'clustalw',
            text: "ClustalW",
            handler: function() {
              Ext.bio.showClustalwWindow(node);
            }
          });
          var ntAppendButton = new Ext.menu.Item({
            iconCls:'blast',
            text: "Blast vs NR-NT",
            handler: function() {
              Ext.bio.showBlastNtAppendWindow(node);
            }
          });

          contextMenu  = new Ext.menu.Menu({
            items: [ clustalwButton,ntAppendButton,'-',deleteButton]
          });

        } else if (node.attributes.db_type == "Uploaded Cleaned Database") {
          contextMenu  = new Ext.menu.Menu({
            items: [ blastButton, '-', deleteButton]
          });
        } else if (node.attributes.db_type == "Uploaded Raw Data") {
          var cleanButton = new Ext.menu.Item({
            iconCls:'book',
            text: "Clean DB",
            handler: function() {
              Ext.bio.showBlastCleanerWindow(node);
            }
          });

          contextMenu  = new Ext.menu.Menu({
            items: [renameButton, cleanButton, blastButton, '-', deleteButton]
          });
        } else if (node.attributes.db_type == "Database Group") {
          var ntGroupAppendButton = new Ext.menu.Item({
            iconCls:'blast',
            text: "Blast vs NR-NT",
            handler: function() {
              Ext.bio.showBlastGroupNtAppendWindow(node);
            }
          });
          var groupClustalwButton = new Ext.menu.Item({
            iconCls:'clustalw',
            text: "ClustalW",
            handler: function() {
              Ext.bio.showClustalwWindow(node);
            }
          });

          contextMenu  = new Ext.menu.Menu({
            items: [ntGroupAppendButton,groupClustalwButton,  '-', deleteButton]
          });

        } else {
          contextMenu  = new Ext.menu.Menu({
            items: [deleteButton]
          });
        }
      }
      else if (node.attributes.resource == 'biodatabase_group') {
      }
      else if (node.attributes.resource == 'fasta_file') {
        var menuItems =[];
        var uploadFastaButton = new Ext.menu.Item({
          iconCls:'upload-icon',
          text: "Upload Fasta File",
          handler: function() {
            Ext.bio.showFastaFileUploadWindow();
          }
        });
        menuItems[0] = uploadFastaButton;

        if (node.childNodes.length==0) {
          var extractSequencesButton = new Ext.menu.Item({
            iconCls:'sequence-icon',
            text: "Extract Sequences",
            handler:function() {
              Ext.bio.showExtractSequencesWindow(node);
            }
          });
          menuItems[1] = extractSequencesButton ;
        }
        contextMenu  = new Ext.menu.Menu({
          items: menuItems
        });
      }
      if (contextMenu) {
        contextMenu.show(node.ui.getAnchor());
      }
    }
  },
  addDatabaseGroup: function(){
    Ext.Msg.prompt('New Database group', 'Enter new database group name:',
      function(btn, text){
        var dbTree = Ext.getCmp('bio-database-group-tree');
        var url;
        var params = {};
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
Ext.reg('workbench-tree', Ext.bio.WorkbenchTree);

