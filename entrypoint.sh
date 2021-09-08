#!/usr/bin/env bash
while getopts e:b:d:r:v: flag
do
    case "${flag}" in
        e) event_path=${OPTARG};;
        b) base_version=${OPTARG};;
        d) debug=${OPTARG};;
        r) repository=${OPTARG};;
        v) released_version=${OPTARG};;
    esac
done
echo "Read args"

if [ -z ${event_path+x} ];
then
	event_path="./event.json"
fi

if [ -z ${repository+x} ];
then
	repository=$(jq -r .repository.full_name $event_path)
fi
[[ -n $debug ]] && echo "Detected Github Repository: $repository"

if [ -z ${released_version+x} ];
then
	released_version=$(jq -r .release.tag_name $event_path)
fi
[[ -n $debug ]] && echo "Detected Released version: $released_version"

lib/lead_time_extraction.rb $repository $released_version $base_version

