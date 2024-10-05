import os
import cv2


def capture_frames(video_path, output_folder):
    # 检查输出文件夹是否存在，如果存在则添加尾缀
    original_output_folder = output_folder
    counter = 1
    while os.path.exists(output_folder):
        output_folder = f"{original_output_folder}_{counter}"
        counter += 1

    os.makedirs(output_folder)

    # 打开视频文件
    cap = cv2.VideoCapture(video_path)

    if not cap.isOpened():
        print(f"Error: Could not open video {video_path}.")
        return

    # 获取视频的帧率
    fps = cap.get(cv2.CAP_PROP_FPS)
    frame_interval = int(fps * 5)  # 每5秒的帧数

    frame_count = 0
    saved_frame_count = 0

    while True:
        ret, frame = cap.read()

        if not ret:
            break

        if frame_count % frame_interval == 0:
            frame_filename = os.path.join(
                output_folder, f"frame_{saved_frame_count * 5}.jpg"
            )
            cv2.imwrite(frame_filename, frame)
            saved_frame_count += 1

        frame_count += 1

    cap.release()
    print(f"Saved {saved_frame_count} frames from {video_path}.")


if __name__ == "__main__":
    current_folder = os.getcwd()
    mp4_files = [f for f in os.listdir(current_folder) if f.endswith(".mp4")]

    if not mp4_files:
        print("当前文件夹中没有找到任何 .mp4 文件。")
    else:
        for video_file in mp4_files:
            video_path = os.path.join(current_folder, video_file)
            output_folder = os.path.join(
                current_folder, os.path.splitext(video_file)[0] + "_frames"
            )
            capture_frames(video_path, output_folder)
