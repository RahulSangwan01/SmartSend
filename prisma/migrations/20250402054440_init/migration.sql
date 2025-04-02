/*
  Warnings:

  - You are about to drop the `VerificationToken` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[accountId]` on the table `Account` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[username]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[stripe_subscription_id]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[stripe_customer_id]` on the table `User` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateEnum
CREATE TYPE "Plan" AS ENUM ('FREE', 'PRO', 'MAX');

-- AlterTable
ALTER TABLE "Account" ADD COLUMN     "accountId" SERIAL NOT NULL,
ADD COLUMN     "email" TEXT;

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "auto_update" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "change_to_free_plan_on_period_end" BOOLEAN DEFAULT false,
ADD COLUMN     "email_processed" INTEGER,
ADD COLUMN     "last_free_tier_refill_date" TIMESTAMP(3),
ADD COLUMN     "last_updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "next_ai_analysys" TIMESTAMP(3),
ADD COLUMN     "stripe_current_period_end" TIMESTAMP(3),
ADD COLUMN     "stripe_customer_id" TEXT,
ADD COLUMN     "stripe_price_id" TEXT,
ADD COLUMN     "stripe_subscription_id" TEXT,
ADD COLUMN     "update_primary" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "update_promo" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "update_social" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "update_update" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "username" TEXT;

-- DropTable
DROP TABLE "VerificationToken";

-- CreateTable
CREATE TABLE "UserSettings" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "email_notify" BOOLEAN NOT NULL DEFAULT true,
    "inbox_primary" BOOLEAN NOT NULL DEFAULT true,
    "inbox_social" BOOLEAN NOT NULL DEFAULT false,
    "inbox_promo" BOOLEAN NOT NULL DEFAULT false,
    "inbox_update" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserSettings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "description" TEXT,
    "color" TEXT,
    "predefinedId" INTEGER,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProcessedEmails" (
    "id" TEXT NOT NULL,
    "emailId" TEXT NOT NULL,
    "emailAddress" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "summary" TEXT,
    "actions" TEXT[],
    "is_important" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ProcessedEmails_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProcessedEmailsOnTags" (
    "emailId" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,

    CONSTRAINT "ProcessedEmailsOnTags_pkey" PRIMARY KEY ("emailId","tagId")
);

-- CreateTable
CREATE TABLE "Inbox" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Inbox_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "verificationTokens" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "verificationTokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "passwordResetTokens" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "passwordResetTokens_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Tag_userId_label_key" ON "Tag"("userId", "label");

-- CreateIndex
CREATE UNIQUE INDEX "ProcessedEmails_emailId_key" ON "ProcessedEmails"("emailId");

-- CreateIndex
CREATE UNIQUE INDEX "verificationTokens_token_key" ON "verificationTokens"("token");

-- CreateIndex
CREATE UNIQUE INDEX "verificationTokens_email_token_key" ON "verificationTokens"("email", "token");

-- CreateIndex
CREATE UNIQUE INDEX "passwordResetTokens_token_key" ON "passwordResetTokens"("token");

-- CreateIndex
CREATE UNIQUE INDEX "passwordResetTokens_email_token_key" ON "passwordResetTokens"("email", "token");

-- CreateIndex
CREATE UNIQUE INDEX "Account_accountId_key" ON "Account"("accountId");

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "User_stripe_subscription_id_key" ON "User"("stripe_subscription_id");

-- CreateIndex
CREATE UNIQUE INDEX "User_stripe_customer_id_key" ON "User"("stripe_customer_id");

-- AddForeignKey
ALTER TABLE "UserSettings" ADD CONSTRAINT "UserSettings_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tag" ADD CONSTRAINT "Tag_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProcessedEmails" ADD CONSTRAINT "ProcessedEmails_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProcessedEmailsOnTags" ADD CONSTRAINT "ProcessedEmailsOnTags_emailId_fkey" FOREIGN KEY ("emailId") REFERENCES "ProcessedEmails"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProcessedEmailsOnTags" ADD CONSTRAINT "ProcessedEmailsOnTags_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Inbox" ADD CONSTRAINT "Inbox_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
