
Ext.bio.BiodatabaseRenamerForm =  Ext.extend(Ext.FormPanel,{
  cancelAction: function() {
  // Client should override
  },
  initComponent: function() {
    var parentComponentId = this.id;
    Ext.apply(this,{
      url:'/tools/biosequence_renamers.json',
      method: 'POST',
      labelAlign: 'top',
      baseParams:{
        authenticity_token: FORM_AUTH_TOKEN
      },
      items: [
      new Ext.form.ComboBox({
        store: this.dbStore,
        displayField: 'name',
        typeAhead: true,
        mode: 'local',
        triggerAction: 'all',
        emptyText:'Select a Database...',
        selectOnFocus:true,
        width:135,
        allowBlank:false
      }), {
        fieldLabel: 'New Prefix',
        name: 'prefix',
        allowBlank:false
      }
      ],
      buttons: [{
        text: 'Save',
        handler: function(){
          var form = Ext.getCmp(parentComponentId).getForm()
          form.submit({
            url:'/tools/biosequence_renamers.json',
            method: 'POST'
          });
        }
      },{
        text: 'Cancel',
        handler: function() {
          Ext.getCmp(parentComponentId).cancelAction();
        }
      }]

    });
    Ext.bio.BiodatabaseRenamerForm.superclass.initComponent.call(this);
  },
  frame:true,
  bodyStyle:'padding:5px 5px 0',
  defaultType: 'textfield',
  id: 'my-form-panel'

});

Ext.reg('bio-db-renamer-form', Ext.bio.BiodatabaseRenamerForm) ;
Ext.bio.BiodatabaseRenamerWindow = Ext.extend(Ext.Window,{
  title: 'Rename Sequences',
  layout:'fit',
  width:500,
  height:220,
  closeAction:'hide',
  plain: true,
  id:'bio-db-renamer-window',

  initComponent: function() {
    var parentComponentId = this.id;
    Ext.apply(this,{
      items: [{
        border: false,
        iconCls: 'nav' ,
        dbStore: this.dbStore,
        xtype: 'bio-db-renamer-form',
        id: 'bio-db-renamer-form',
        cancelAction: function() {
          Ext.getCmp(parentComponentId).hide();
        }
      }]
    });
    Ext.bio.BiodatabaseRenamerWindow.superclass.initComponent.call(this);
  }
});