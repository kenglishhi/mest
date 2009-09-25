

Ext.bio.DatabaseGroupTree =  Ext.extend(Ext.tree.TreePanel, {
  dataUrl: null,
  treeData: null,
  title: 'Units',
  initComponent: function() {


    // THIS EXAMPLE WORKS, don't delete.
    //        var rootNode = new Ext.tree.AsyncTreeNode({
    //            "text": "Office of the Mayor of Honolulu",
    //            "root": true,
    //            "leaf": false,
    //            "id": 75,
    //            "expandable": true,
    //             "expanded": true,
    //             children: [{"view": "", "expanded": false, "parent_id": 75, "text": "CAP Office", "root": false, "name": "CAP Office", "iconCls": "icon-docs", "leaf": true, "id": 1470, "loaded": false, "expandable": false}, {"view": "", "expanded": false, "parent_id": 75, "text": "Department of Emergency Management", "root": false, "name": "Department of Emergency Management", "iconCls": "icon-docs", "leaf": false, "id": 78, "loaded": false, "expandable": true}, {"view": "", "expanded": false, "parent_id": 75, "text": "Department of Emergency Services", "root": false, "name": "Department of Emergency Services", "iconCls": "icon-docs", "leaf": true, "id": 77, "loaded": false, "expandable": false}, {"view": "", "expanded": false, "parent_id": 75, "text": "Honolulu Fire Department", "root": false, "name": "Honolulu Fire Department", "iconCls": "icon-docs", "leaf": false, "id": 74, "loaded": false, "expandable": true}, {"view": "", "expanded": false, "parent_id": 75, "text": "Honolulu Police Department", "root": false, "name": "Honolulu Police Department", "iconCls": "icon-docs", "leaf": true, "id": 76, "loaded": false, "expandable": false}, {"view": "", "expanded": false, "parent_id": 75, "text": "Springer Condo", "root": false, "name": "Springer Condo", "iconCls": "icon-docs", "leaf": true, "id": 1469, "loaded": false, "expandable": false}, {"view": "", "expanded": false, "parent_id": 75, "text": "Venues", "root": false, "name": "Venues", "iconCls": "icon-docs", "leaf": false, "id": 1449, "loaded": false, "expandable": true}]
    ////                loaded: true,
    ////                text: 'Tree Root',
    //            });
    var rootNode = new Ext.tree.AsyncTreeNode(this.treeData[0]);


    Ext.apply(this, {
      autoScroll: true,
      region: 'west',
      contentEl: 'tree',
      width: 250,
      collapsible: true,
      split: true,
      rootVisible: true,
      loader: new Ext.tree.TreeLoader({
        dataUrl: this.dataUrl,
        requestMethod: 'GET'
      }),

      root: rootNode
    });
    Ext.bio.DatabaseGroupTree.superclass.initComponent.call(this);
  },
  listeners: {
    click: function(node) {
       this.clickAction(node);
    },
    collapsenode: function(node) {
      if (!this.treecookie) {
     	  this.treecookie = new Cookie( this.cookieName );
        this.treecookie.expanded_nodes = [];
      }
      this.treecookie.expanded_nodes.remove(node.attributes.id);
      this.treecookie.store(1);
    },
    expandnode: function(node) {
      if (!this.treecookie) {
     	  this.treecookie = new Cookie( this.cookieName );
        this.treecookie.expanded_nodes = [];
      }


     if (this.treecookie.expanded_nodes.indexOf(node.attributes.id) == -1) {
        this.treecookie.expanded_nodes.push(node.attributes.id);
     }
     this.treecookie.store(1);
    }
  }
});
Ext.reg('database-group-tree', Ext.ux.DatabaseGroupTree);

