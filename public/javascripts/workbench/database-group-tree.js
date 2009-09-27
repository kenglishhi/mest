
Ext.bio.DatabaseGroupTree =  Ext.extend(Ext.tree.TreePanel, {
  dataUrl: null,
  treeData: null,
  title: 'Databases',
  initComponent: function() {

    var rootNode = new Ext.tree.AsyncTreeNode(this.treeData);

    Ext.apply(this, {
      border: false,
      autoScroll: true,
      animate: true,
      enableDD: true,
      useArrows: true,
      loader: new Ext.tree.TreeLoader(),
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
  }
});
Ext.reg('database-group-tree', Ext.bio.DatabaseGroupTree);

