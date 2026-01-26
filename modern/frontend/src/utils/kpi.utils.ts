import type { GoalRating, PlanRating } from '@/types/kpi.types';

/**
 * Check if employee can submit ratings
 * All ratings must be filled for allowed quarters
 */
export const canEmployeeSubmitRatings = (ratings: GoalRating[]): boolean => {
  if (!ratings || ratings.length === 0) return false;

  return ratings.every((goal) => {
    const allowedQuarters = goal.allowedQuarter?.split(',') || [];

    return allowedQuarters.every((quarter) => {
      const quarterTrimmed = quarter.trim();
      const ratingKey = `${quarterTrimmed.toLowerCase()}_Rating` as keyof GoalRating;
      const rating = goal[ratingKey];
      return rating !== null && rating !== undefined;
    });
  });
};

/**
 * Check if manager can submit review
 * All manager ratings must be filled
 */
export const canManagerSubmitRatings = (goals: GoalRating[]): boolean => {
  if (!goals || goals.length === 0) return false;

  return goals.every((goal) => {
    return goal.managerRating !== null && goal.managerRating !== undefined;
  });
};

/**
 * Get KPI status display text
 */
export const getKPIStatusText = (planId: number | null, isReviewed: boolean | null): string => {
  if (!planId) return 'Not Created';
  if (isReviewed === null) return 'Assigned';
  if (isReviewed === false) return 'Submitted';
  if (isReviewed === true) return 'Reviewed';
  return 'Unknown';
};

/**
 * Get KPI status color
 */
export const getKPIStatusColor = (planId: number | null, isReviewed: boolean | null): string => {
  if (!planId) return 'error';
  if (isReviewed === null) return 'warning';
  if (isReviewed === false) return 'info';
  if (isReviewed === true) return 'success';
  return 'default';
};

/**
 * Check if quarter is allowed for a goal
 */
export const isQuarterAllowed = (allowedQuarter: string, quarter: string): boolean => {
  const allowed = allowedQuarter?.split(',').map((q) => q.trim()) || [];
  return allowed.includes(quarter);
};

/**
 * Get rating for a specific quarter
 */
export const getQuarterRating = (goal: GoalRating, quarter: string): number | null => {
  const ratingKey = `${quarter.toLowerCase()}_Rating` as keyof GoalRating;
  return (goal[ratingKey] as number | null) || null;
};

/**
 * Get note for a specific quarter
 */
export const getQuarterNote = (goal: GoalRating, quarter: string): string | null => {
  const noteKey = `${quarter.toLowerCase()}_Note` as keyof GoalRating;
  return (goal[noteKey] as string | null) || null;
};

/**
 * Calculate next appraisal date
 */
export const calculateNextAppraisalDate = (
  joiningDate: string,
  lastReviewDate?: string | null
): string => {
  if (lastReviewDate) {
    const date = new Date(lastReviewDate);
    date.setFullYear(date.getFullYear() + 1);
    return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
  }

  const joining = new Date(joiningDate);
  const currentYear = new Date().getFullYear();
  const joiningYear = joining.getFullYear();

  const yearToUse = joiningYear < currentYear - 1 ? joiningYear + 1 : currentYear + 1;

  joining.setFullYear(yearToUse);
  return joining.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
};

/**
 * Format date for display
 */
export const formatDisplayDate = (dateString: string | null): string => {
  if (!dateString) return 'N/A';
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
};

/**
 * Get current plan from ratings array
 */
export const getCurrentPlan = (ratings: PlanRating[]): PlanRating | null => {
  if (!ratings || ratings.length === 0) return null;

  // Find the most recent plan (highest planId or latest reviewDate)
  return (
    ratings.sort((a, b) => {
      if (b.planId !== a.planId) return b.planId - a.planId;
      return new Date(b.reviewDate).getTime() - new Date(a.reviewDate).getTime();
    })[0] || null
  );
};
