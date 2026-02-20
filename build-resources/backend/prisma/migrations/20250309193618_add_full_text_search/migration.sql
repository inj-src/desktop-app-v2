-- Create function to update doctors search vector
CREATE OR REPLACE FUNCTION publicDoctor_search_vector_update() RETURNS trigger AS $$
BEGIN
  NEW."searchVector" :=
    setweight(to_tsvector('english', COALESCE(NEW.name, '')), 'A') ||
    setweight(to_tsvector('english', COALESCE(NEW.designation, '')), 'B') ||
    setweight(to_tsvector('english', COALESCE(NEW.specialties, '')), 'B') ||
    setweight(to_tsvector('english', COALESCE(NEW.qualifications, '')), 'C');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create function to update hospitals search vector
CREATE OR REPLACE FUNCTION publicHospital_search_vector_update() RETURNS trigger AS $$
BEGIN
  NEW."searchVector" :=
    setweight(to_tsvector('english', COALESCE(NEW.name, '')), 'A') ||
    setweight(to_tsvector('english', COALESCE(NEW.location, '')), 'B') ||
    setweight(to_tsvector('english', COALESCE(NEW.services, '')), 'B') ||
    setweight(to_tsvector('english', COALESCE(NEW.introduction, '')), 'C');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers
CREATE TRIGGER publicDoctor_search_vector_update
  BEFORE INSERT OR UPDATE ON "publicDoctor"
  FOR EACH ROW
  EXECUTE FUNCTION publicDoctor_search_vector_update();

CREATE TRIGGER publicHospital_search_vector_update
  BEFORE INSERT OR UPDATE ON "publicHospital"
  FOR EACH ROW
  EXECUTE FUNCTION publicHospital_search_vector_update();

-- Update existing records
UPDATE "publicDoctor" SET "searchVector" = 
  setweight(to_tsvector('english', COALESCE(name, '')), 'A') ||
  setweight(to_tsvector('english', COALESCE(designation, '')), 'B') ||
  setweight(to_tsvector('english', COALESCE(specialties, '')), 'B') ||
  setweight(to_tsvector('english', COALESCE(qualifications, '')), 'C');

UPDATE "publicHospital" SET "searchVector" = 
  setweight(to_tsvector('english', COALESCE(name, '')), 'A') ||
  setweight(to_tsvector('english', COALESCE(location, '')), 'B') ||
  setweight(to_tsvector('english', COALESCE(services, '')), 'B') ||
  setweight(to_tsvector('english', COALESCE(introduction, '')), 'C');