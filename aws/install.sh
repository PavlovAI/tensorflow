# !/bin/bash

cd ~

# CUDA 7.0 toolkit
# When prompted: Scroll all the way down > accept > y > y > y > default (/usr/local/cuda-7.0) > y > n
curl -O http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/cuda_7.0.28_linux.run
chmod +x cuda_7.0.28_linux.run
sudo ./cuda_7.0.28_linux.run

sudo modprobe nvidia
nvidia-smi

# CUDNN 6.5
curl -O https://s3.amazonaws.com/pavlov-utils/cudnn-6.5-linux-x64-v2.tgz
tar zxfv cudnn-6.5-linux-x64-v2.tgz
sudo cp cudnn-6.5-linux-x64-v2/cudnn.h /usr/local/cuda-7.0/include
sudo cp cudnn-6.5-linux-x64-v2/libcudnn* /usr/local/cuda-7.0/lib64

# env
echo | tee -a ~/.bash_profile >/dev/null <<EOF
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/cuda/lib64
export CUDA_HOME=/usr/local/cuda
EOF

# Java (for bazel)
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get -y install oracle-java8-installer

# bazel
git clone https://github.com/bazelbuild/bazel.git
cd bazel
git checkout tags/0.1.0
./compile.sh
cd ..

# tensorflow
git clone --recurse-submodules https://github.com/pavlovml/tensorflow
cd tensorflow
(cd third_party/gpus/cuda; ./cuda_config.sh;)
../bazel/output/bazel build -c opt --config=cuda //tensorflow/cc:tutorials_example_trainer
../bazel/output/bazel build -c opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/pip
sudo pip install /tmp/pip/*.whl

# cleanup
rm -rf cudnn-6.5-linux-x64-v2
rm cuda_7.0.28_linux.run
rm cuda-repo-ubuntu1404_7.0-28_amd64.deb
rm cudnn-6.5-linux-x64-v2.tgz
rm install.sh
