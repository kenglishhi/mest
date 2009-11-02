/*!
 * biodatabase-grid.js
 * Kevin English, University of Hawaii
 */

Ext.bio.BiodatabaseGroupGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  useEditorFlag:true,
  usePagingBarFlag: true,
  displayColumns:  [ {
    header: "Name",
    width: 100,
    sortable: true,
    dataIndex: 'name',
    editor: new Ext.form.TextField({})
  } ],
  initComponent: function() {
    Ext.bio.BiodatabaseGroupGrid.superclass.initComponent.call(this);
  }
});
Ext.reg('biodatabase-group-grid', Ext.bio.BiodatabaseGroupGrid);

