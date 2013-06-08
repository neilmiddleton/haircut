Sequel.migration do
  up do
    create_table :urls do
      primary_key :id
      String :url
      String :short_url
      Integer :hit_count
    end

    run 'ALTER SEQUENCE urls_id_seq RESTART WITH 10000;'
  end

  down do
    drop_table :urls
  end
end
