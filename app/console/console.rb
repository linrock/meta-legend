module MetaLegend
  module Console
    # convenience functions

    def migrate(hsreplay_id)
      CombinedReplayDataMigrator.new(hsreplay_id).migrate!
    end

    def rx(hsreplay_id)
      ReplayXmlData.find_by(hsreplay_id: hsreplay_id)
    end

    def rh(hsreplay_id)
      ReplayHtmlData.find_by(hsreplay_id: hsreplay_id)
    end

    def ro(hsreplay_id)
      ReplayOutcome.find_by(hsreplay_id: hsreplay_id)
    end

    def rg(hsreplay_id)
      ReplayGameApiResponse.find_by(hsreplay_id: hsreplay_id)
    end
  end
end
