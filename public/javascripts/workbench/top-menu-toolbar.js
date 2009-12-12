Ext.bio.TopMenuToolbar =  Ext.extend(Ext.Toolbar, {
  menuData: {},

  initComponent: function() {
    var menuData = this.menuData;
    var projectOptions = this.menuData.projectOptions;
    var projectCombo  = new Ext.form.ComboBox({
      store: new Ext.data.ArrayStore({
        fields: ['id', 'name'],
        data : projectOptions
      }),
      displayField: 'name',
      valueField:'id',
      typeAhead: false,
      allowBlank: false,
      editable: false,
      mode: 'local',
      triggerAction: 'all',
      emptyText:'Select a Project...',
      selectOnFocus:true,
      forceSelection:true,
      autowidth:true,
      width:200
    });
    projectCombo.setValue( menuData.currentProjectId );
    projectCombo.on('select', function(box, record) {
      var controllerUrl = menuData.changeProjectUrl + '/' + record.data.id ;
      //controllerUrl = controllerUrl.replace(/xxx_new_selected_unit/,record.data.unit_id );
      window.location = controllerUrl;
    });

    Ext.apply(this,{
      items:   [
      {
        xtype: 'tbtext',
        text: this.menuData.mest_html ,
        cls:'north-header',
        id: 'mest-menu-title'
      } ,'-', {
        xtype: 'tbtext',
        text: this.menuData.home_html ,
        cls:'north-header',
        id: 'home-menu-title'
      } ,'-',{
        xtype: 'tbtext',
        text: this.menuData.workbench_html ,
        cls:'north-header',
        id: 'workbench-menu-title'
      } ,'-',{
        xtype: 'tbtext',
        text: this.menuData.admin_html ,
        cls:'north-header',
        id: 'admin-menu-title'
      },
      '->',
      '-',
      'Logged in as <b>' + this.menuData.currentUserDisplayName + '</b>',
     '-',
      'Select Project ',
      ' ' ,
      projectCombo,
      '    ' ,
      '-',
      {
        text: '<b>Logout</b>',
        handler: function(){
          window.location = '/logout';
        }
      }]
    });
    Ext.bio.TopMenuToolbar.superclass.initComponent.call(this);

  }

});