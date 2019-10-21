#!/bin/sh


#check that GPG_PASS is defined

cd rpmbuild && rpmbuild -ba SPECS/openliberty.spec
if [ -z "$GPG_PASS" ]
then
     echo "GPG PASSPHRASE is undefined.  skip signing of rpm/deb packages"
     cd ../debuild/openliberty/debian && debuild -d -b -us -uc
else 
     #!/bin/sh
     #run commands to build the deb 
     echo "${GPG_PASS}" > ~/.gnupg/pp.txt
     if gpg -k |grep admin ; then
         echo gpg key imported correctly
	 cd ../debuild/openliberty/debian && debuild -d -b -p'gpg --passphrase-file ~/.gnupg/pp.txt --batch'  -e"admin@openliberty.io"
     else
         echo gpg key not imported correctly
         cd ../debuild/openliberty/debian && debuild -d -b -us -uc
     fi
     rm -f ~/.gnupg/pp.txt
fi










