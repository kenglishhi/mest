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
  deleteSelectedRow: function(confirm,name_field,postDeleteFn) {
    var grid = this;
    var rec = grid.getSelectionModel().getSelected();
    var rowIndex = grid.getSelectionModel().last;
    if (rec) {
      if (confirm)  {
        Ext.MessageBox.confirm('Confirm', 'Are you sure you want to delete "' + rec.data[name_field] +'"?',
          function(btn){
            if (btn == 'yes') {
              //              Ext.getCmp(cmpId).store.remove(rec);
              grid.store.remove(rec);
              grid.selModel.selectRow(rowIndex);
              if (postDeleteFn) {
                postDeleteFn({ 
                  rowIndex: rowIndex
                }) ;
              }
            }
          });

      } else {
        grid.store.remove(rec);
        grid.selModel.selectRow(rowIndex);
        if (postDeleteFn) {
          postDeleteFn({
            rowIndex: rowIndex
          }) ;
        }
      }
    }
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