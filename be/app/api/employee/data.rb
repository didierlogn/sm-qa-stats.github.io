module Employee
  class Data < Grape::API
    resource :qa_stats do
          format :json
      desc "list"
     
      get '/:id' do
       
       # {"id" => params[:id]}
       # EmpData.all


      $apitoken = "8ae303c4f23ff4af5a6bcfb10ab8507e"
      puts "Generating Report ..."

      $totalstoriesUrl = "https://www.pivotaltracker.com/services/v5/projects/1151468/stories?filter=label:"+params[:id]+"%20and%20includedone:true%20and%20type:feature&limit=10000000"
      @totalstoriesRequest = RestClient::Resource.new( $totalstoriesUrl )
      @totalstoriesResponse = @totalstoriesRequest.get( :'X-TrackerToken' => $apitoken )
      @totalstories = JSON.parse(@totalstoriesResponse.to_str)

      $bugsUrl = "https://www.pivotaltracker.com/services/v5/projects/1151468/stories?filter=label:"+params[:id]+"%20and%20label:test-cases-added%20and%20includedone:true%20and%20type:feature&limit=10000000"
      @bugRequest = RestClient::Resource.new( $bugsUrl )
      @bugsResponse = @bugRequest.get( :'X-TrackerToken' => $apitoken )
      @bugs = JSON.parse(@bugsResponse.to_str)

          $count = 0
          @story_count = 0 
          puts "Total  of stories: "+ @bugs.length.to_s

          @bugs.each do |bug|
              @story_count = @story_count + 1 
                #puts bug

                $storyid = bug["id"]
              #  puts "this is"+ $storyid

                 $taskUrl = "https://www.pivotaltracker.com/services/v5/projects/1151468/stories/"+$storyid.to_s+"/tasks"

                @storyRequest = RestClient::Resource.new( $taskUrl )
                @storyResponse = @storyRequest.get( :'X-TrackerToken' => $apitoken )
                @tasks = JSON.parse(@storyResponse.to_str)

                  @tasks.each do |task|
                  #  puts task
                    if task["description"].include? "https://schoolmint.testrail.net/index.php?"
                    $count = $count + 1
                    end

                  end
          end

          puts "Total  of test cases: "+ $count.to_s

          {"total-stories" => @totalstories.length.to_s,
            "total-stories-w-test-cases" => @bugs.length.to_s,
            "total-test-cases-created" => $count.to_s
          }

      end     
    end
  end
end
