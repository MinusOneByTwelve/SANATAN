-- AlterTable
CREATE SEQUENCE stackoption_identifierid_seq;
ALTER TABLE "StackOption" ALTER COLUMN "identifierId" SET DEFAULT nextval('stackoption_identifierid_seq');
ALTER SEQUENCE stackoption_identifierid_seq OWNED BY "StackOption"."identifierId";
