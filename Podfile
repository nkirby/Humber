#####################################
# Humber
# 
#####################################

workspace 'Humber.xcworkspace'
project 'Humber/Humber.xcodeproj'

use_frameworks!
inhibit_all_warnings!

def networking
  pod 'Alamofire'
end

def coreLibs
  pod 'AsyncSwift'
  pod 'FDKeychain'
  pod 'Janus'
  pod 'JLRoutes'
  pod 'PINCache'
  pod 'ReactiveCocoa'
end

def dataStorage
  pod 'RealmSwift'
end

#####################################

target 'Humber' do
  platform :ios, '9.0'
  project 'Humber/Humber.xcodeproj'
  
  networking
  coreLibs
  dataStorage
  
  pod 'JLRoutes'
  pod 'SnapKit'
end

target 'HMCore' do
  platform :ios, '9.0'
  project '_lib/HMCore/HMCore.xcodeproj'
  
  coreLibs
  dataStorage
  
  pod 'JLRoutes'
end

target 'HMGithub' do
  platform :ios, '9.0'
  project '_lib/HMGithub/HMGithub.xcodeproj'
  
  coreLibs
  dataStorage
  networking
end
