
rm *.proto
cp ../../../../proto/*.proto ./

#echo 'import "google/protobuf/objectivec-descriptor.proto";' >> xm.proto
#echo 'option (google.protobuf.objectivec_file_options).class_prefix = "XM";'>>xm.proto

protoc --plugin=/usr/local/bin/protoc-gen-objc *.proto --objc_out="../xmPB"
#mv ./output/*.* ../xmProto/xmProto