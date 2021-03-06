require 'json'
class ErrataCheckController < ApplicationController
  def sync
    nvrs = JSON.parse(params["nvrs"])
    render :text => "OK", :status => 202

    nvrs.each do |nvr|
        package = Package.first(:conditions => ["brew = ?", nvr])
        if package:
          package.in_errata = nvr
          package.save
        end
    end
  end

  def sync_bz
    bz_bugs = JSON.parse(params["bz_bugs"])
    render :text => "OK", :status => 202

    bz_bugs.each do |bug|
      bz_bug = BzBug.first(:conditions => ["bz_id = ?", bug.to_s])
      if bz_bug:
        bz_bug.is_in_errata = "YES"
        bz_bug.save
      end
    end
  end
end
