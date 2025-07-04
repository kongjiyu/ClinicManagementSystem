<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Bootstrap Demo Page</title>
  <!-- Bootstrap CSS CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">My Bootstrap Site</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link active" href="#">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="#">Features</a></li>
        <li class="nav-item"><a class="nav-link" href="#">Contact</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- Jumbotron / Hero Section -->
<div class="container mt-4">
  <div class="p-5 mb-4 bg-light rounded-3">
    <div class="container-fluid py-5">
      <h1 class="display-5 fw-bold">Welcome to Bootstrap</h1>
      <p class="col-md-8 fs-4">This is a simple example page showcasing Bootstrap components.</p>
      <button class="btn btn-primary btn-lg">Learn More</button>
    </div>
  </div>
</div>

<!-- Cards -->
<div class="container">
  <div class="row g-4">
    <div class="col-md-4">
      <div class="card">
        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4uRGyMTuckDXMTinVCCFGJKdt0fnBlfEvGg&s" class="card-img-top" alt="Card Image">
        <div class="card-body">
          <h5 class="card-title">Card One</h5>
          <p class="card-text">This is some example text for the first card.</p>
          <a href="#" class="btn btn-outline-primary">Read More</a>
        </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card">
        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4uRGyMTuckDXMTinVCCFGJKdt0fnBlfEvGg&s" class="card-img-top" alt="Card Image">
        <div class="card-body">
          <h5 class="card-title">Card Two</h5>
          <p class="card-text">This is some example text for the second card.</p>
          <a href="#" class="btn btn-outline-primary">Read More</a>
        </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card">
        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4uRGyMTuckDXMTinVCCFGJKdt0fnBlfEvGg&s" class="card-img-top" alt="Card Image">
        <div class="card-body">
          <h5 class="card-title">Card Three</h5>
          <p class="card-text">This is some example text for the third card.</p>
          <a href="#" class="btn btn-outline-primary">Read More</a>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Bootstrap JS CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
