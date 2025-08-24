package utils;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;

/**
 * Utility class for handling timezone-specific operations
 * Malaysia is UTC+8, so when it's 11:16 AM in Malaysia, it's 3:16 AM UTC
 */
public class TimeUtils {
    
    // Malaysia timezone (UTC+8)
    private static final ZoneId MALAYSIA_ZONE = ZoneId.of("Asia/Kuala_Lumpur");
    
    /**
     * Get current time in Malaysia timezone
     * @return LocalDateTime in Malaysia timezone
     */
    public static LocalDateTime nowMalaysia() {
        return LocalDateTime.now(MALAYSIA_ZONE);
    }
    
    /**
     * Convert UTC time to Malaysia time
     * @param utcTime UTC time
     * @return LocalDateTime in Malaysia timezone
     */
    public static LocalDateTime toMalaysiaTime(LocalDateTime utcTime) {
        if (utcTime == null) {
            return null;
        }
        ZonedDateTime utcZoned = utcTime.atZone(ZoneId.of("UTC"));
        ZonedDateTime malaysiaZoned = utcZoned.withZoneSameInstant(MALAYSIA_ZONE);
        return malaysiaZoned.toLocalDateTime();
    }
    
    /**
     * Convert Malaysia time to UTC
     * @param malaysiaTime Malaysia time
     * @return LocalDateTime in UTC
     */
    public static LocalDateTime toUTCTime(LocalDateTime malaysiaTime) {
        if (malaysiaTime == null) {
            return null;
        }
        ZonedDateTime malaysiaZoned = malaysiaTime.atZone(MALAYSIA_ZONE);
        ZonedDateTime utcZoned = malaysiaZoned.withZoneSameInstant(ZoneId.of("UTC"));
        return utcZoned.toLocalDateTime();
    }
}
