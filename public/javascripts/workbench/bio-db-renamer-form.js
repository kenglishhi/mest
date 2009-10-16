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
    var combo =       new Ext.form.ComboBox({
      fieldLabel: 'Database',
      name:'biodatabase',
      id:'biodatabase-id-id-field',
      hiddenName : 'biodatabase_id',
      valueField:'id',
      displayField:'name',
      store: this.dbStore,
      typeAhead: true,
      mode: 'remote',
      triggerAction: 'all',
      emptyText:'Select a database...',
      selectOnFocus:true,
      width: 350,
      listWidth: 350,
      allowBlank:false
    });
    var form = new Ext.FormPanel({
      id: 'my-bio-form-panel',
      labelWidth: 75, // label settings here cascade unless overridden
      url:'/tools/biosequence_renamers.json',
      method: 'POST',
      baseParams:{
        authenticity_token: FORM_AUTH_TOKEN
      },
      frame:true,
      bodyStyle:'padding:5px 5px 0',
      defaults: {
        width: 230
      },
      defaultType: 'textfield',
      items: [combo
      , {
        fieldLabel: 'New Prefix',
        name: 'prefix',
        allowBlank:false
      }
      ],
      buttons: [{
        text: 'Save',
        handler: function(){
          var form = Ext.getCmp('my-bio-form-panel').getForm();
          if (form) {
            form.submit();
          }
          Ext.getCmp(parentComponentId).hide();
        }
      },
      {
        text: 'Cancel',
        handler: function(){
          Ext.getCmp(parentComponentId).hide();
        }
      }
      ]
    }
    );



    Ext.apply(this,{
      items: [  form ]
    //        {
    //        border: false,
    //        dbStore: this.dbStore,
    //        xtype: 'bio-db-renamer-form',
    //        id: 'bio-db-renamer-form',
    //        cancelAction: function() {
    //          Ext.getCmp(parentComponentId).hide();
    //        }
    //      }
    //    ]
    });
    Ext.bio.BiodatabaseRenamerWindow.superclass.initComponent.call(this);
  }
});