/*!
 * job-grid.js
 * Kevin English, University of Hawaii
 */

Ext.bio.JobLogGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  useEditorFlag:false,
  usePagingBarFlag: true,
  displayColumns:  [ {
    header: "Job Name",
    autoWidth: true,
    sortable: true,
    dataIndex: 'job_name'
  }
  /*, {
    header: "Run At",
    autoWidth: true,
    sortable: true,
    dataIndex: 'run_at'
  }, {
    header: "Priority",
    autoWidth: true,
    sortable: true,
    dataIndex: 'priority'
  }
  */
  ],
  updateContent: function(params) {
      this.store.load();
  },
  initComponent: function() {
    Ext.bio.JobLogGrid.superclass.initComponent.call(this);
  }
});
Ext.reg('job-log-grid', Ext.bio.JobLogGrid);