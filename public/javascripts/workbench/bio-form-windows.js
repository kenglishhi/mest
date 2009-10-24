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
    var combo = new Ext.form.ComboBox({
      fieldLabel: 'Database',
      name:'biodatabase',
      id:'biodatabase-id-rename-field',
      hiddenName : 'biodatabase_id',
      valueField:'id',
      displayField:'name',
      store: this.dbStore,
      typeAhead: true,
      mode: 'local',
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
          if (form && form.isValid()) {
            form.submit({
              success: function(form, action) {
                Ext.getCmp(parentComponentId).hide();
              //Ext.bio.notifier.show('Sequences Renamed', 'Finished renaming seqeuneces');
              }
            });
          }
        }
      },
      {
        text: 'Cancel',
        handler: function(){
          Ext.getCmp(parentComponentId).hide();
        }
      }
      ]
    });

    Ext.apply(this,{ 
      items:   form
    });
    Ext.bio.BiodatabaseRenamerWindow.superclass.initComponent.call(this);
  }
});

Ext.bio.BlastCleanerWindow = Ext.extend(Ext.Window,{
  title: 'Clean DB with Blasth',
  layout:'fit',
  width:500,
  height:220,
  closeAction:'hide',
  plain: true,
  id:'bio-blast-cleaners-window',
  initComponent: function() {
    var parentComponentId = this.id;
    var combo = new Ext.form.ComboBox({
      fieldLabel: 'Database',
      name:'biodatabase',
      id:'biodatabase-id-cleant-field',
      hiddenName : 'biodatabase_id',
      valueField:'id',
      displayField:'name',
      store: this.dbStore,
      typeAhead: true,
      mode: 'local',
      triggerAction: 'all',
      emptyText:'Select a database...',
      selectOnFocus:true,
      width: 350,
      listWidth: 350,
      allowBlank:false
    });
    var form = new Ext.FormPanel({
      id: 'my-blast-cleaners-form-panel',
      labelWidth: 120, // label settings here cascade unless overridden
      url:'/tools/blast_cleaners.json',
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
      items: [combo,
      {
        fieldLabel: 'New Database Name',
        name: 'new_biodatabase_name',
        allowBlank:true,
        msgTarget:'side'
      } , {
        fieldLabel: 'E-Value',
        name: 'evalue',
        value:'25',
        allowBlank:true
      }
      ],
      buttons: [{
        text: 'Submit',
        handler: function(){
          var form = Ext.getCmp('my-blast-cleaners-form-panel').getForm();
          if (form && form.isValid()) {
            form.submit({
              waitMsg:"Submitting...",
              success: function(form, action) {
                //Ext.bio.notifier.show('Sequences Renamed', 'Finished renaming seqeuneces');
                Ext.getCmp(parentComponentId).hide();
              }
            });
          }
        }
      },
      {
        text: 'Cancel',
        handler: function(){
          Ext.getCmp(parentComponentId).hide();
        }
      }
      ]
    });

    Ext.apply(this,{
      items:   form
    });
    Ext.bio.BlastCleanerWindow.superclass.initComponent.call(this);
  }
});


Ext.bio.BlastCreateDbsWindow = Ext.extend(Ext.Window,{
  title: 'Blast & Create DBs',
  layout:'fit',
  width:500,
  height:220,
  closeAction:'hide',
  plain: true,
  id:'bio-blast-window',
  initComponent: function() {
    var parentComponentId = this.id;

    var testCombo = new Ext.form.ComboBox({
      fieldLabel: 'Test Database',
      name:'biodatabase',
      id:'test-biodatabase-id-blast-field',
      hiddenName : 'test_biodatabase_id',
      valueField:'id',
      displayField:'name',
      store: this.dbStore,
      typeAhead: true,
      mode: 'local',
      triggerAction: 'all',
      emptyText:'Select a test database...',
      selectOnFocus:true,
      width: 350,
      listWidth: 350,
      allowBlank:false
    });
    var targetCombo = new Ext.form.ComboBox({
      fieldLabel: 'Target Database',
      name:'biodatabase',
      id:'target-biodatabase-id-blast-field',
      hiddenName : 'target_biodatabase_id',
      valueField:'id',
      displayField:'name',
      store: this.dbStore,
      typeAhead: true,
      mode: 'local',
      triggerAction: 'all',
      emptyText:'Select a target database...',
      selectOnFocus:true,
      width: 350,
      listWidth: 350,
      allowBlank:false
    });


    var form = new Ext.FormPanel({
      id: 'my-blast-form-panel',
      labelWidth: 120, // label settings here cascade unless overridden
      url:'/tools/blast_create_dbs.json',
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
      items: [testCombo, targetCombo,
      {
        fieldLabel: 'Output DB Group',
        name: 'output_biodatabase_group_name',
        allowBlank:true,
        msgTarget:'side'
      } , {
        fieldLabel: 'E-Value',
        name: 'evalue',
        value:'25',
        allowBlank:true
      }],
      buttons: [{
        text: 'Submit',
        handler: function(){
          var form = Ext.getCmp('my-blast-cleaners-form-panel').getForm();
          if (form && form.isValid()) {
            form.submit({
              waitMsg:"Submitting...",
              success: function(form, action) {
                //Ext.bio.notifier.show('Sequences Renamed', 'Finished renaming seqeuneces');
                Ext.getCmp(parentComponentId).hide();
              }
            });
          }
        }
      },
      {
        text: 'Cancel',
        handler: function(){
          Ext.getCmp(parentComponentId).hide();
        }
      }
      ]
    });

    Ext.apply(this,{
      items:   form
    });
    Ext.bio.BlastCreateDbsWindow.superclass.initComponent.call(this);
  }
});
