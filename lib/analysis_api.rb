require 'google/cloud/vision'
require 'httparty'
require 'uri'

class ImageAnalysis

    def get_labels(image_url)

        project_id = "pollock-212623"
        vision = Google::Cloud::Vision.new project: project_id

        results = []
        image = vision.image image_url

        image.labels.each do |label|
            results.push(label.description)
        end
        return results
    end

    def get_emotions(labels)

        text = labels.join(', ')
        text = URI.escape(text)

        pollock_api = 'https://calm-cliffs-20905.herokuapp.com/api/v1/resources?image_caption='

        response = HTTParty.get(pollock_api + text)
        json = JSON.parse(response.body)
    end

end