# Extracts xml data in batches + fork to prevent memory leaks
# from leading the server to run out of memory

ReplayXmlData.find_in_batches(batch_size: 100).with_index do |group, i|
  puts "Processing group #{i}"
  pid = fork do
    group.each(&:extract_and_save_xml_data)
  end
  Process.wait pid
end
