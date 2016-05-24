# Determine which style of argument is being
# used. These match the SPL types in
# com.ibm.streamsx.topology/types.spl
#
# SPL TYPE - style - comment
# blob __spl_po - python - pickled Python object
# rstring string - string - SPL rstring
# rstring jsonString - json - JSON as SPL rstring
# xml document - xml - XML document
# blob binary - binary - Binary data
#
# tuple<...> - tuple - Any SPL tuple type apart from above
#
# Not all are supported yet.
# 
# We only check the attribute name here as
# these operators are only invoked by the PAA

sub splpy_tuplestyle{

 my ($port) = @_;

 my $attr =  $port->getAttributeAt(0);
 my $pystyle = 'unk';
 my $itupleType = $port->getSPLTupleType();
 my $numattrs = $port->getNumberOfAttributes();
 if (($numattrs == 1) && ($attr->getName() eq '__spl_po')) {
    $pystyle = 'pickle';
 } elsif (($numattrs == 1) && ($attr->getName() eq 'string')) {
    $pystyle = 'string';
 } elsif (($numattrs == 1) && ($attr->getName() eq 'jsonString')) {
    $pystyle = 'json';
 }
 else {
    $pystyle = 'spltuple';
 }

 return $pystyle;
}

# Given a style return a string containing
# the C++ code to get the value
# from an input tuple ip, that will
# be converted to Python and passed to the function.
#
sub splpy_inputtuple2value{
 my ($pystyle) = @_;
 if ($pystyle eq 'pickle') {
  return 'SPL::blob value = ip.get___spl_po();';
 }

 if ($pystyle eq 'string') {
  return 'SPL::rstring value = ip.get_string();';
 }

 if ($pystyle eq 'json') {
  return 'SPL::rstring value = ip.get_jsonString();';
 }

 if ($pystyle eq 'spltuple') {
  # nothing done here for spltuple style 
 }
}
1;
