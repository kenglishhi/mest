Ext.bio.AlignmentViewPanel =  Ext.extend(Ext.Panel, {
  title: 'My Alignment',
  initComponent: function() {
    Ext.apply(this,{
      title: 'Alignment',
      items: [{
        id:'inner-alignment-panel',
        html: "No Alignment to preview "
      }],
      tbar: [{
        text:'Update content',
        viewPanelId: this.id,
        handler: function() {
          Ext.getCmp(this.viewPanelId).updateContent();
        }
      }]
    })
    Ext.bio.AlignmentViewPanel.superclass.initComponent.call(this);
  },
  updateContent: function() {
    var viewPanelId= this.id;
    console.log("updateContent");
    Ext.Ajax.request({
      url: 'http://mest/system/fastas/24/original/EST_Clade_A_5_vs_Combined-EST_Clade_A_1-EST_Clade_A_3-EST_Clade_A_5-A_1_Clean-A_3_Clean_002.aln',
      success: function(response) {
        var clustalwOutputLines = response.responseText.split("\n");
        var clustalwOutput="";
        var i;
        var seqProcessedFlag = false ;
        var clustalwOutput = '<table>';
        for (i =0; i < clustalwOutputLines.length; i++) {
          var line = clustalwOutputLines[i];
          if (line.match(/^CLUSTAL/)) {
          //clustalwOutput += line +  '<br />';
          } else if (line.length == 0 && seqProcessedFlag  )  {
            clustalwOutput +=  '<br />';
          } else if (line.length ==0)  {
          } else if (line.match(/\*\*\*\*\*$/)) {
          //clustalwOutput +=  line +  '<br />';
            clustalwOutput  += '<tr>&nbsp;</td><td>' + line  + '</td></tr>';
          }  else {
            var seqs = line.split(/\s+/);
            seqs[1] = seqs[1].replace(/(A+)/g, "<span class='dna-a'>$1</span>");
            seqs[1] = seqs[1].replace(/(T+)/g, "<span class='dna-t'>$1</span>");
            seqs[1] = seqs[1].replace(/(C+)/g, "<span class='dna-c'>$1</span>");
//            clustalwOutput += seqs[0] + "--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--" + seqs[1] +  '<br />';
            clustalwOutput  += '<tr>' +  seqs[0] + '</td><td>' + seqs[1]  + '</td></tr>';
            seqProcessedFlag  = true;
          }
        }
        clustalwOutput += '</table>';

        //.        clustalwOutput = clustalwOutput.replace(/(A+)/g, "<span class='dna-a'>$1</span>");
        //        clustalwOutput = clustalwOutput.replace(/(T+)/g, "<span class='dna-t'>$1</span>");
        //        clustalwOutput = clustalwOutput.replace(/(C+)/g, "<span class='dna-c'>$1</span>");
        Ext.getCmp('inner-alignment-panel').getEl().update(clustalwOutput);
      //        cmp.update(response.responseText);
      },
      headers: {
      },
      params: {
    }
    });

  }
});

Ext.reg('alignment-view-panel', Ext.bio.AlignmentViewPanel);