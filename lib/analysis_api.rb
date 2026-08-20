require 'google/cloud/vision'
require "ibm_watson/natural_language_understanding_v1"
include IBMWatson
require 'httparty'
require 'uri'

class ImageAnalysis

    def get_labels(image_url)

        project_id = "pollock-212623"
        image_annotator = Google::Cloud::Vision::ImageAnnotator.new

        results = []
        rep = image_annotator.label_detection(
	        image: image_url
        )

        rep.responses.each do |res|
            res.label_annotations.each do |label|
                results.push(label.description)
            end
        end
        return results
    end

    def get_emotions(labels)

        text = labels.join(', ')
        text = URI.escape(text)

        pollock_api = 'https://calm-cliffs-20905.herokuapp.com/api/v1/resources?image_caption='

        natural_language_understanding = IBMWatson::NaturalLanguageUnderstandingV1.new(
            version: "2019-07-12",
            iam_apikey: "#{ENV['WATSON_CREDS']}",
            url: "#{ENV['WATSON_URL']}"
        )

        response = natural_language_understanding.analyze(
            text: text,
            features: {emotion: {targets: labels, document: true}}
        )
        #json = JSON.parse(response.result)
        result = {'sentiment' => response.result}
        puts "GENERATING RESULT: "
        p result['sentiment']
        return result

    end

    def process_emotions(result)
        return result
    end

end