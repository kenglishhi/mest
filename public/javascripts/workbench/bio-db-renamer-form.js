
Ext.bio.BiodatabaseRenamerForm =  Ext.extend(Ext.FormPanel,{
  initComponent: function() {
    var parentComponentId = this.id;
    Ext.apply(this,{
      url:'/tools/biosequence_renamers.json',
      method: 'POST',
      labelAlign: 'top',
      height:500,
      baseParams:{
        authenticity_token: FORM_AUTH_TOKEN
      },
      items: [
      new Ext.form.ComboBox({

        fieldLabel: 'Database',
        hiddenName:'biodatabase_id',
        store: new Ext.data.ArrayStore({
          fields: ['biodatabase_id', 'name'],
          data : [ ['3', 'EST_Clade_A_6' ] ]
        }),
        valueField:'biodatabase_id',
        displayField:'name',
        typeAhead: true,
        mode: 'local',
        triggerAction: 'all',
        emptyText:'Select a database...',
        selectOnFocus:true,
        width:200,
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
          console.log("Do Save");
          var form = Ext.getCmp(parentComponentId).getForm()
          form.submit({
            url:'/tools/biosequence_renamers.json',
            method: 'POST'
          });
        }
      }]

    });
    Ext.bio.BiodatabaseRenamerForm.superclass.initComponent.call(this);
  },
  frame:true,
  title: 'Simple Form',
  bodyStyle:'padding:5px 5px 0',
  defaultType: 'textfield',
  id: 'my-form-panel'

});

Ext.reg('bio-db-renamer-form', Ext.bio.BiodatabaseRenamerForm) ;
