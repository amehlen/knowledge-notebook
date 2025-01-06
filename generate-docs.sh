#!/bin/bash

# Current folder (for docker volume)
current_folder="/$(pwd)"
echo "Current folder: $current_folder"

docker_image="asciidoctor/docker-asciidoctor"
echo "Docker image for asciidoctor: $docker_image"

output_folder="output"
theme_file="resources/themes/custom-theme.yml"
fonts="resources/fonts"

# Prepare output folder
echo "Preparing output folder..."
rm -rf "$output_folder" && mkdir -p "$output_folder"

for asciidoc_file in docs/*/index.adoc; do
  asciidoc_file_path="$(dirname "$asciidoc_file")"
  topic="$(basename "$asciidoc_file_path")"
  output_file="$output_folder/$topic.pdf"
  theme_file_path="$asciidoc_file_path/$theme_file"
  fonts_path="$asciidoc_file_path/$fonts"

  echo "Generating PDF for: $topic"
  echo "Input file: $asciidoc_file"
  echo "Use theme file: $theme_file_path"
  echo "Fonts folder: $fonts"
  echo "Output file: $output_file"

  docker run --rm -v "$current_folder:/documents/" $docker_image asciidoctor-pdf \
    -r asciidoctor-diagram \
    -r asciidoctor-mathematical \
    -a pdf-theme="$theme_file_path" \
    -a pdf-fontsdir="$fonts_path" "$asciidoc_file" \
    -o "$output_file"
done