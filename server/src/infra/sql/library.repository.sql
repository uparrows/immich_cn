-- NOTE: This file is auto generated by ./sql-generator

-- LibraryRepository.get
SELECT DISTINCT
  "distinctAlias"."LibraryEntity_id" AS "ids_LibraryEntity_id"
FROM
  (
    SELECT
      "LibraryEntity"."id" AS "LibraryEntity_id",
      "LibraryEntity"."name" AS "LibraryEntity_name",
      "LibraryEntity"."ownerId" AS "LibraryEntity_ownerId",
      "LibraryEntity"."type" AS "LibraryEntity_type",
      "LibraryEntity"."importPaths" AS "LibraryEntity_importPaths",
      "LibraryEntity"."exclusionPatterns" AS "LibraryEntity_exclusionPatterns",
      "LibraryEntity"."createdAt" AS "LibraryEntity_createdAt",
      "LibraryEntity"."updatedAt" AS "LibraryEntity_updatedAt",
      "LibraryEntity"."deletedAt" AS "LibraryEntity_deletedAt",
      "LibraryEntity"."refreshedAt" AS "LibraryEntity_refreshedAt",
      "LibraryEntity"."isVisible" AS "LibraryEntity_isVisible",
      "LibraryEntity__LibraryEntity_owner"."id" AS "LibraryEntity__LibraryEntity_owner_id",
      "LibraryEntity__LibraryEntity_owner"."name" AS "LibraryEntity__LibraryEntity_owner_name",
      "LibraryEntity__LibraryEntity_owner"."avatarColor" AS "LibraryEntity__LibraryEntity_owner_avatarColor",
      "LibraryEntity__LibraryEntity_owner"."isAdmin" AS "LibraryEntity__LibraryEntity_owner_isAdmin",
      "LibraryEntity__LibraryEntity_owner"."email" AS "LibraryEntity__LibraryEntity_owner_email",
      "LibraryEntity__LibraryEntity_owner"."storageLabel" AS "LibraryEntity__LibraryEntity_owner_storageLabel",
      "LibraryEntity__LibraryEntity_owner"."externalPath" AS "LibraryEntity__LibraryEntity_owner_externalPath",
      "LibraryEntity__LibraryEntity_owner"."oauthId" AS "LibraryEntity__LibraryEntity_owner_oauthId",
      "LibraryEntity__LibraryEntity_owner"."profileImagePath" AS "LibraryEntity__LibraryEntity_owner_profileImagePath",
      "LibraryEntity__LibraryEntity_owner"."shouldChangePassword" AS "LibraryEntity__LibraryEntity_owner_shouldChangePassword",
      "LibraryEntity__LibraryEntity_owner"."createdAt" AS "LibraryEntity__LibraryEntity_owner_createdAt",
      "LibraryEntity__LibraryEntity_owner"."deletedAt" AS "LibraryEntity__LibraryEntity_owner_deletedAt",
      "LibraryEntity__LibraryEntity_owner"."updatedAt" AS "LibraryEntity__LibraryEntity_owner_updatedAt",
      "LibraryEntity__LibraryEntity_owner"."memoriesEnabled" AS "LibraryEntity__LibraryEntity_owner_memoriesEnabled",
      "LibraryEntity__LibraryEntity_owner"."quotaSizeInBytes" AS "LibraryEntity__LibraryEntity_owner_quotaSizeInBytes",
      "LibraryEntity__LibraryEntity_owner"."quotaUsageInBytes" AS "LibraryEntity__LibraryEntity_owner_quotaUsageInBytes"
    FROM
      "libraries" "LibraryEntity"
      LEFT JOIN "users" "LibraryEntity__LibraryEntity_owner" ON "LibraryEntity__LibraryEntity_owner"."id" = "LibraryEntity"."ownerId"
      AND (
        "LibraryEntity__LibraryEntity_owner"."deletedAt" IS NULL
      )
    WHERE
      (("LibraryEntity"."id" = $1))
      AND ("LibraryEntity"."deletedAt" IS NULL)
  ) "distinctAlias"
ORDER BY
  "LibraryEntity_id" ASC
LIMIT
  1

-- LibraryRepository.existsByName
SELECT
  1 AS "row_exists"
FROM
  (
    SELECT
      1 AS dummy_column
  ) "dummy_table"
WHERE
  EXISTS (
    SELECT
      1
    FROM
      "libraries" "LibraryEntity"
    WHERE
      (("LibraryEntity"."name" = $1))
      AND ("LibraryEntity"."deletedAt" IS NULL)
  )
LIMIT
  1

-- LibraryRepository.getCountForUser
SELECT
  COUNT(1) AS "cnt"
FROM
  "libraries" "LibraryEntity"
WHERE
  (("LibraryEntity"."ownerId" = $1))
  AND ("LibraryEntity"."deletedAt" IS NULL)

-- LibraryRepository.getDefaultUploadLibrary
SELECT
  "LibraryEntity"."id" AS "LibraryEntity_id",
  "LibraryEntity"."name" AS "LibraryEntity_name",
  "LibraryEntity"."ownerId" AS "LibraryEntity_ownerId",
  "LibraryEntity"."type" AS "LibraryEntity_type",
  "LibraryEntity"."importPaths" AS "LibraryEntity_importPaths",
  "LibraryEntity"."exclusionPatterns" AS "LibraryEntity_exclusionPatterns",
  "LibraryEntity"."createdAt" AS "LibraryEntity_createdAt",
  "LibraryEntity"."updatedAt" AS "LibraryEntity_updatedAt",
  "LibraryEntity"."deletedAt" AS "LibraryEntity_deletedAt",
  "LibraryEntity"."refreshedAt" AS "LibraryEntity_refreshedAt",
  "LibraryEntity"."isVisible" AS "LibraryEntity_isVisible"
FROM
  "libraries" "LibraryEntity"
WHERE
  (
    (
      "LibraryEntity"."ownerId" = $1
      AND "LibraryEntity"."type" = $2
    )
  )
  AND ("LibraryEntity"."deletedAt" IS NULL)
ORDER BY
  "LibraryEntity"."createdAt" ASC
LIMIT
  1

-- LibraryRepository.getUploadLibraryCount
SELECT
  COUNT(1) AS "cnt"
FROM
  "libraries" "LibraryEntity"
WHERE
  (
    (
      "LibraryEntity"."ownerId" = $1
      AND "LibraryEntity"."type" = $2
    )
  )
  AND ("LibraryEntity"."deletedAt" IS NULL)

-- LibraryRepository.getAllByUserId
SELECT
  "LibraryEntity"."id" AS "LibraryEntity_id",
  "LibraryEntity"."name" AS "LibraryEntity_name",
  "LibraryEntity"."ownerId" AS "LibraryEntity_ownerId",
  "LibraryEntity"."type" AS "LibraryEntity_type",
  "LibraryEntity"."importPaths" AS "LibraryEntity_importPaths",
  "LibraryEntity"."exclusionPatterns" AS "LibraryEntity_exclusionPatterns",
  "LibraryEntity"."createdAt" AS "LibraryEntity_createdAt",
  "LibraryEntity"."updatedAt" AS "LibraryEntity_updatedAt",
  "LibraryEntity"."deletedAt" AS "LibraryEntity_deletedAt",
  "LibraryEntity"."refreshedAt" AS "LibraryEntity_refreshedAt",
  "LibraryEntity"."isVisible" AS "LibraryEntity_isVisible",
  "LibraryEntity__LibraryEntity_owner"."id" AS "LibraryEntity__LibraryEntity_owner_id",
  "LibraryEntity__LibraryEntity_owner"."name" AS "LibraryEntity__LibraryEntity_owner_name",
  "LibraryEntity__LibraryEntity_owner"."avatarColor" AS "LibraryEntity__LibraryEntity_owner_avatarColor",
  "LibraryEntity__LibraryEntity_owner"."isAdmin" AS "LibraryEntity__LibraryEntity_owner_isAdmin",
  "LibraryEntity__LibraryEntity_owner"."email" AS "LibraryEntity__LibraryEntity_owner_email",
  "LibraryEntity__LibraryEntity_owner"."storageLabel" AS "LibraryEntity__LibraryEntity_owner_storageLabel",
  "LibraryEntity__LibraryEntity_owner"."externalPath" AS "LibraryEntity__LibraryEntity_owner_externalPath",
  "LibraryEntity__LibraryEntity_owner"."oauthId" AS "LibraryEntity__LibraryEntity_owner_oauthId",
  "LibraryEntity__LibraryEntity_owner"."profileImagePath" AS "LibraryEntity__LibraryEntity_owner_profileImagePath",
  "LibraryEntity__LibraryEntity_owner"."shouldChangePassword" AS "LibraryEntity__LibraryEntity_owner_shouldChangePassword",
  "LibraryEntity__LibraryEntity_owner"."createdAt" AS "LibraryEntity__LibraryEntity_owner_createdAt",
  "LibraryEntity__LibraryEntity_owner"."deletedAt" AS "LibraryEntity__LibraryEntity_owner_deletedAt",
  "LibraryEntity__LibraryEntity_owner"."updatedAt" AS "LibraryEntity__LibraryEntity_owner_updatedAt",
  "LibraryEntity__LibraryEntity_owner"."memoriesEnabled" AS "LibraryEntity__LibraryEntity_owner_memoriesEnabled",
  "LibraryEntity__LibraryEntity_owner"."quotaSizeInBytes" AS "LibraryEntity__LibraryEntity_owner_quotaSizeInBytes",
  "LibraryEntity__LibraryEntity_owner"."quotaUsageInBytes" AS "LibraryEntity__LibraryEntity_owner_quotaUsageInBytes"
FROM
  "libraries" "LibraryEntity"
  LEFT JOIN "users" "LibraryEntity__LibraryEntity_owner" ON "LibraryEntity__LibraryEntity_owner"."id" = "LibraryEntity"."ownerId"
  AND (
    "LibraryEntity__LibraryEntity_owner"."deletedAt" IS NULL
  )
WHERE
  (
    (
      "LibraryEntity"."ownerId" = $1
      AND "LibraryEntity"."isVisible" = $2
    )
  )
  AND ("LibraryEntity"."deletedAt" IS NULL)
ORDER BY
  "LibraryEntity"."createdAt" ASC

-- LibraryRepository.getAll
SELECT
  "LibraryEntity"."id" AS "LibraryEntity_id",
  "LibraryEntity"."name" AS "LibraryEntity_name",
  "LibraryEntity"."ownerId" AS "LibraryEntity_ownerId",
  "LibraryEntity"."type" AS "LibraryEntity_type",
  "LibraryEntity"."importPaths" AS "LibraryEntity_importPaths",
  "LibraryEntity"."exclusionPatterns" AS "LibraryEntity_exclusionPatterns",
  "LibraryEntity"."createdAt" AS "LibraryEntity_createdAt",
  "LibraryEntity"."updatedAt" AS "LibraryEntity_updatedAt",
  "LibraryEntity"."deletedAt" AS "LibraryEntity_deletedAt",
  "LibraryEntity"."refreshedAt" AS "LibraryEntity_refreshedAt",
  "LibraryEntity"."isVisible" AS "LibraryEntity_isVisible",
  "LibraryEntity__LibraryEntity_owner"."id" AS "LibraryEntity__LibraryEntity_owner_id",
  "LibraryEntity__LibraryEntity_owner"."name" AS "LibraryEntity__LibraryEntity_owner_name",
  "LibraryEntity__LibraryEntity_owner"."avatarColor" AS "LibraryEntity__LibraryEntity_owner_avatarColor",
  "LibraryEntity__LibraryEntity_owner"."isAdmin" AS "LibraryEntity__LibraryEntity_owner_isAdmin",
  "LibraryEntity__LibraryEntity_owner"."email" AS "LibraryEntity__LibraryEntity_owner_email",
  "LibraryEntity__LibraryEntity_owner"."storageLabel" AS "LibraryEntity__LibraryEntity_owner_storageLabel",
  "LibraryEntity__LibraryEntity_owner"."externalPath" AS "LibraryEntity__LibraryEntity_owner_externalPath",
  "LibraryEntity__LibraryEntity_owner"."oauthId" AS "LibraryEntity__LibraryEntity_owner_oauthId",
  "LibraryEntity__LibraryEntity_owner"."profileImagePath" AS "LibraryEntity__LibraryEntity_owner_profileImagePath",
  "LibraryEntity__LibraryEntity_owner"."shouldChangePassword" AS "LibraryEntity__LibraryEntity_owner_shouldChangePassword",
  "LibraryEntity__LibraryEntity_owner"."createdAt" AS "LibraryEntity__LibraryEntity_owner_createdAt",
  "LibraryEntity__LibraryEntity_owner"."deletedAt" AS "LibraryEntity__LibraryEntity_owner_deletedAt",
  "LibraryEntity__LibraryEntity_owner"."updatedAt" AS "LibraryEntity__LibraryEntity_owner_updatedAt",
  "LibraryEntity__LibraryEntity_owner"."memoriesEnabled" AS "LibraryEntity__LibraryEntity_owner_memoriesEnabled",
  "LibraryEntity__LibraryEntity_owner"."quotaSizeInBytes" AS "LibraryEntity__LibraryEntity_owner_quotaSizeInBytes",
  "LibraryEntity__LibraryEntity_owner"."quotaUsageInBytes" AS "LibraryEntity__LibraryEntity_owner_quotaUsageInBytes"
FROM
  "libraries" "LibraryEntity"
  LEFT JOIN "users" "LibraryEntity__LibraryEntity_owner" ON "LibraryEntity__LibraryEntity_owner"."id" = "LibraryEntity"."ownerId"
  AND (
    "LibraryEntity__LibraryEntity_owner"."deletedAt" IS NULL
  )
WHERE
  "LibraryEntity"."deletedAt" IS NULL
ORDER BY
  "LibraryEntity"."createdAt" ASC

-- LibraryRepository.getAllDeleted
SELECT
  "LibraryEntity"."id" AS "LibraryEntity_id",
  "LibraryEntity"."name" AS "LibraryEntity_name",
  "LibraryEntity"."ownerId" AS "LibraryEntity_ownerId",
  "LibraryEntity"."type" AS "LibraryEntity_type",
  "LibraryEntity"."importPaths" AS "LibraryEntity_importPaths",
  "LibraryEntity"."exclusionPatterns" AS "LibraryEntity_exclusionPatterns",
  "LibraryEntity"."createdAt" AS "LibraryEntity_createdAt",
  "LibraryEntity"."updatedAt" AS "LibraryEntity_updatedAt",
  "LibraryEntity"."deletedAt" AS "LibraryEntity_deletedAt",
  "LibraryEntity"."refreshedAt" AS "LibraryEntity_refreshedAt",
  "LibraryEntity"."isVisible" AS "LibraryEntity_isVisible",
  "LibraryEntity__LibraryEntity_owner"."id" AS "LibraryEntity__LibraryEntity_owner_id",
  "LibraryEntity__LibraryEntity_owner"."name" AS "LibraryEntity__LibraryEntity_owner_name",
  "LibraryEntity__LibraryEntity_owner"."avatarColor" AS "LibraryEntity__LibraryEntity_owner_avatarColor",
  "LibraryEntity__LibraryEntity_owner"."isAdmin" AS "LibraryEntity__LibraryEntity_owner_isAdmin",
  "LibraryEntity__LibraryEntity_owner"."email" AS "LibraryEntity__LibraryEntity_owner_email",
  "LibraryEntity__LibraryEntity_owner"."storageLabel" AS "LibraryEntity__LibraryEntity_owner_storageLabel",
  "LibraryEntity__LibraryEntity_owner"."externalPath" AS "LibraryEntity__LibraryEntity_owner_externalPath",
  "LibraryEntity__LibraryEntity_owner"."oauthId" AS "LibraryEntity__LibraryEntity_owner_oauthId",
  "LibraryEntity__LibraryEntity_owner"."profileImagePath" AS "LibraryEntity__LibraryEntity_owner_profileImagePath",
  "LibraryEntity__LibraryEntity_owner"."shouldChangePassword" AS "LibraryEntity__LibraryEntity_owner_shouldChangePassword",
  "LibraryEntity__LibraryEntity_owner"."createdAt" AS "LibraryEntity__LibraryEntity_owner_createdAt",
  "LibraryEntity__LibraryEntity_owner"."deletedAt" AS "LibraryEntity__LibraryEntity_owner_deletedAt",
  "LibraryEntity__LibraryEntity_owner"."updatedAt" AS "LibraryEntity__LibraryEntity_owner_updatedAt",
  "LibraryEntity__LibraryEntity_owner"."memoriesEnabled" AS "LibraryEntity__LibraryEntity_owner_memoriesEnabled",
  "LibraryEntity__LibraryEntity_owner"."quotaSizeInBytes" AS "LibraryEntity__LibraryEntity_owner_quotaSizeInBytes",
  "LibraryEntity__LibraryEntity_owner"."quotaUsageInBytes" AS "LibraryEntity__LibraryEntity_owner_quotaUsageInBytes"
FROM
  "libraries" "LibraryEntity"
  LEFT JOIN "users" "LibraryEntity__LibraryEntity_owner" ON "LibraryEntity__LibraryEntity_owner"."id" = "LibraryEntity"."ownerId"
WHERE
  (
    "LibraryEntity"."isVisible" = $1
    AND NOT ("LibraryEntity"."deletedAt" IS NULL)
  )
ORDER BY
  "LibraryEntity"."createdAt" ASC

-- LibraryRepository.getStatistics
SELECT
  "libraries"."id" AS "libraries_id",
  "libraries"."name" AS "libraries_name",
  "libraries"."ownerId" AS "libraries_ownerId",
  "libraries"."type" AS "libraries_type",
  "libraries"."importPaths" AS "libraries_importPaths",
  "libraries"."exclusionPatterns" AS "libraries_exclusionPatterns",
  "libraries"."createdAt" AS "libraries_createdAt",
  "libraries"."updatedAt" AS "libraries_updatedAt",
  "libraries"."deletedAt" AS "libraries_deletedAt",
  "libraries"."refreshedAt" AS "libraries_refreshedAt",
  "libraries"."isVisible" AS "libraries_isVisible",
  COUNT("assets"."id") FILTER (
    WHERE
      "assets"."type" = 'IMAGE'
      AND "assets"."isVisible"
  ) AS "photos",
  COUNT("assets"."id") FILTER (
    WHERE
      "assets"."type" = 'VIDEO'
      AND "assets"."isVisible"
  ) AS "videos",
  COALESCE(SUM("exif"."fileSizeInByte"), 0) AS "usage"
FROM
  "libraries" "libraries"
  LEFT JOIN "assets" "assets" ON "assets"."libraryId" = "libraries"."id"
  AND ("assets"."deletedAt" IS NULL)
  LEFT JOIN "exif" "exif" ON "exif"."assetId" = "assets"."id"
WHERE
  ("libraries"."id" = $1)
  AND ("libraries"."deletedAt" IS NULL)
GROUP BY
  "libraries"."id"

-- LibraryRepository.getOnlineAssetPaths
SELECT
  "assets"."originalPath" AS "assets_originalPath"
FROM
  "libraries" "library"
  INNER JOIN "assets" "assets" ON "assets"."libraryId" = "library"."id"
  AND ("assets"."deletedAt" IS NULL)
WHERE
  (
    "library"."id" = $1
    AND "assets"."isOffline" = false
  )
  AND ("library"."deletedAt" IS NULL)

-- LibraryRepository.getAssetIds
SELECT
  "assets"."id" AS "assets_id"
FROM
  "libraries" "library"
  INNER JOIN "assets" "assets" ON "assets"."libraryId" = "library"."id"
  AND ("assets"."deletedAt" IS NULL)
WHERE
  ("library"."id" = $1)
  AND ("library"."deletedAt" IS NULL)
