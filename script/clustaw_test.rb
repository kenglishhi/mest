seqs = [ 'atgca', 'aagca', 'acgca', 'acgcg' ]
seqs = seqs.collect{ |x| Bio::Sequence::NA.new(x) }
# creates alignment object
a = Bio::Alignment.new(seqs)
a.consensus 
# ==> "a?gc?"
# shows IUPAC consensus
a.consensus_iupac 
# ==> "ahgcr"
# iterates over each seq
a.each { |x| p x }
# ==>
#    "atgca"
#    "aagca"
#    "acgca"
#    "acgcg"
# iterates over each site
a.each_site { |x| p x }
# ==>
#    ["a", "a", "a", "a"]
#    ["t", "a", "c", "c"]
#    ["g", "g", "g", "g"]
#    ["c", "c", "c", "c"]
#    ["a", "a", "a", "g"]
 
# doing alignment by using CLUSTAL W.
# clustalw command must be installed.
factory = Bio::ClustalW.new
a2 = a.do_align(factory)
