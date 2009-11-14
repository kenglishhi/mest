/*!
 * bio-restfulgrid.js
 * Kevin English, University of Hawaii
 */

Ext.bio.RestfulGrid =  Ext.extend(Ext.grid.GridPanel, {
  height: 300,
  displayColumns: [ ],
  readerColumns:[ ],
  useEditorFlag:false,
  updateContent: function(params) {
  },
  initComponent: function() {

    var plugins = [];
    if (this.useEditorFlag){
      plugins[0] = this.editor;
      var editor = new Ext.ux.grid.RowEditor({
        saveText: 'Update'
      });
      plugins[0] = editor;
    }
    var pagingBar = null;
    if (this.usePagingBarFlag){
      pagingBar = new Ext.PagingToolbar({
        store: this.store,
        pageSize: this.pageSize,
        displayInfo: true,
        displayMsg: 'Displaying {0} - {1} of {2}',
        emptyMsg: "No data to display"
      });
    }


    Ext.apply(this,{
      bbar: pagingBar,
      loadMask: true,
      iconCls: 'icon-grid',
      frame: true,
      autoScroll: true,
      //      autoHeight: true,
      plugins: plugins,
      columns : this.displayColumns,
      viewConfig: {
        forceFit: true
      }
    });

    Ext.bio.RestfulGrid.superclass.initComponent.call(this);
  } ,
  listeners: {
    render: function( p)  {
      this.store.load();
    }
  }
});